import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firebase_functions/auth_service.dart';
import 'log_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _authService.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const LogInScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 150,
            ),
            const Text(
              'Handy',
              style: TextStyle(
                  color: Color(0xFFFFDB58),
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
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
                            hintText: 'Username'),
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                      ),
                      child: TextField(
                        controller: _emailController,
                        decoration:
                            const InputDecoration.collapsed(hintText: 'Email'),
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
                            hintText: 'Password'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _signUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Create New Account',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
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
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        backgroundColor: Color(0xFFFFDB58),
                        child: const Text(
                          'Log In',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }


}
