import 'package:facebook/screens/log_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

@override
  void dispose() {
  _usernameController.dispose();
  _emailController.dispose();
  _passwordController.dispose();
  super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 150,
            ),
            const Text(
              'facebook',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
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
                        decoration:
                        new InputDecoration.collapsed(hintText: 'Username'),
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                      ),
                      child: TextField(
                        controller: _emailController,
                        decoration:
                        new InputDecoration.collapsed(hintText: 'Email'),
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
                        decoration:
                        new InputDecoration.collapsed(hintText: 'Password'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 25),
                      width: double.infinity,
                      child: FloatingActionButton(
                        onPressed: () async {
                          String message = '';
                          try {
                            var data = await _auth.createUserWithEmailAndPassword( // instantiated earlier on: final _firebaseAuth = FirebaseAuth.instance;
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                            print(data);
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LogInScreen(),));

                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              message = 'The password provided is too weak.';
                            } else if (e.code == 'email-already-in-use') {
                              message = 'An account already exists with that email.';
                            }
                            print(message);
                          } catch (e) {
                            print(e.toString());
                          }
                        },
                        backgroundColor: Colors.green,
                        child: const Text(
                          'Create New Account',
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
                      child: FloatingActionButton(
                        onPressed: () {

                          Navigator.pop(context);
                        },
                        backgroundColor: Colors.blue,
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
      );

  }
     _signUp() async{
      String usename=_usernameController.text;
      String email=_emailController.text;
      String password=_passwordController.text;

      UserCredential? user = await _auth.createUserWithEmailAndPassword(email: email, password: password,);
      return user;
    }
  }

