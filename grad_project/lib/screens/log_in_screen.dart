import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:grad_project/screensCutomers/sign_up_screen.dart';

import '../screensWorkers/layout_screen_wroker.dart';
import '../screensCutomers/layout_screen.dart'; // Replace with HomeScreen for customers


class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  String _statusMessage = '';

  Future<void> _login() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Sign in the user with Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Get the current user's UID
      String uid = userCredential.user!.uid;

      // Check if the user exists in the `customers` collection
      DocumentSnapshot customerDoc =
      await _firestore.collection('Customers').doc(uid).get();

      if (customerDoc.exists) {
        // Navigate to HomeScreen for customers
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LayoutScreen()),
        );
      } else {
        // Check if the user exists in the `workers` collection
        DocumentSnapshot workerDoc =
        await _firestore.collection('workers').doc(uid).get();

        if (workerDoc.exists) {
          // Navigate to HomeScreenWorker for workers
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LayoutScreenWorker()),
          );
        } else {
          // If the user doesn't exist in either collection
          setState(() {
            _statusMessage = 'User not found in the system.';
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _statusMessage = e.message ?? 'Unknown error occurred';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 150,
              ),
              const Text(
                'Handy',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                      ),
                      child: TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Email',
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                      ),
                      child: TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Password',
                        ),
                        obscureText: true,
                      ),
                    ),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Container(
                      margin: const EdgeInsets.symmetric(vertical: 25),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    if (_statusMessage.isNotEmpty)
                      Text(
                        _statusMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    GestureDetector(
                      child: const Text(
                        'Forgotten password?',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          child: const Text("or"),
                        ),
                        const Expanded(
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'Create New Account',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
