import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook/screens/home_screen.dart';
import 'package:facebook/screens/layout_screen.dart';
import 'package:facebook/screens/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _statusMessage = '';

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Login success, navigate to home screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LayoutScreen()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        _statusMessage = e.message ?? 'Unknown error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 150,
            ),
            const Text(
              'facebook',
              style: TextStyle(
                  color: Colors.blue, fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 35,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                    ),
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration.collapsed(hintText: 'Email'),
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                    ),
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration.collapsed(hintText: 'Password'),
                      obscureText: true, // To hide the password input
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 25),
                    width: double.infinity,
                    child: ElevatedButton(
                      // Use ElevatedButton instead of FloatingActionButton
                      onPressed: () {
                        _login(); // Call the _login method
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 15),
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
                    margin: EdgeInsets.symmetric(vertical: 30),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 15),
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
    );
  }
}
