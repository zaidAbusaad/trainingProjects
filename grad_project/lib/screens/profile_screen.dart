import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  bool isLoading = true;

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
          });
        }
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
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
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
                  )),
                ],
              ],
            ),
          ),
        ),
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
