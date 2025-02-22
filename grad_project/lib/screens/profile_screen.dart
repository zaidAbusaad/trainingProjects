import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grad_project/components/header.dart';

import 'log_in_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool isWorker; // Passed to determine worker or customer

  const ProfileScreen({Key? key, required this.isWorker}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String name = '';
  int age = 0;
  String email = '';
  String phoneNumber = '';
  List<String> professions = [];
  List<double> ratings = [];
  bool isLoading = true;
  double average = 0.0;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        String collectionName = widget.isWorker ? 'workers' : 'Customers';
        DocumentSnapshot userSnapshot =
        await _firestore.collection(collectionName).doc(currentUser.uid).get();

        if (userSnapshot.exists) {
          setState(() {
            name = userSnapshot['name'];
            age = userSnapshot['age'];
            email = userSnapshot['email'];
            phoneNumber = userSnapshot['phoneNumber'];

            if (widget.isWorker) {
              professions = List<String>.from(userSnapshot['professions']);
            }
          print("rating fetch start");
            List<dynamic> rawRatings = userSnapshot['ratings'] ?? [];
            ratings = rawRatings.map((rating) => (rating is int) ? rating.toDouble() : rating as double).toList();
            print("rating fetch ends");
          });
        }

      }
      if (ratings.isNotEmpty) {
        // Calculate the sum of all ratings
        double sum = ratings.reduce((a, b) => a + b);

        // Calculate the average
        average = sum / ratings.length.toDouble();

        print('Average Rating: $average');
      } else {
        print('No ratings available');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          Header(title: 'Profile',backBtn: false,),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        name,
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent),
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(thickness: 1, color: Colors.grey),
                    SizedBox(height: 10),
                    buildProfileDetail('Age', age.toString()),
                    buildProfileDetail('Email', email),
                    buildProfileDetail('Phone', phoneNumber),
                    if(widget.isWorker)
                      buildProfileDetail('Rate', average.toString()),
                    if (widget.isWorker) ...[
                      SizedBox(height: 20),
                      Text(
                        'Professions:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      SizedBox(height: 10),
                      ...professions.map((profession) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Icon(Icons.check, color: Colors.blueAccent, size: 20),
                            SizedBox(width: 10),
                            Text(
                              profession,
                              style: TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      ),
                    ],
                    // ElevatedButton(
                    //   onPressed: () => _logout(context),
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.grey, // Logout button color
                    //   ),
                    //   child: const Text('History',style: TextStyle(color: Colors.white),),
                    // ),
                    ElevatedButton(
                      onPressed: () => _logout(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Logout button color
                      ),
                      child: const Text('Logout',style: TextStyle(color: Colors.white),),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 18, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
Future<void> _logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut(); // Sign out the user
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LogInScreen()),
          (route) => false, // Remove all previous routes
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to log out: $e')),
    );
  }
}