import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/screens/sign_up_screen.dart';

import 'layout_screen.dart';

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
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );
      setState(() {
        _isLoading = true;
      });
      // Login success, navigate to home screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LayoutScreen()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        _statusMessage = e.message ?? 'Unknown error occurred';
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
                    color: Color(0xFFFFDB58), fontSize: 30, fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
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
                        decoration: const InputDecoration.collapsed(hintText: 'Email'),
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
                        decoration: const InputDecoration.collapsed(hintText: 'Password'),
                        obscureText: true, // To hide the password input
                      ),
                    ),
                    _isLoading
                        ? const CircularProgressIndicator()
                    :Container(
                      margin: const EdgeInsets.symmetric(vertical: 25),
                      width: double.infinity,
                      child: ElevatedButton(
                        // Use ElevatedButton instead of FloatingActionButton
                        onPressed: () {
                          _login(); // Call the _login method
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFDB58),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'Log In',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
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
                            )),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          child: const Text("or"),
                        ),
                        const Expanded(
                            child: Divider(
                              color: Colors.black,
                            )),
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
