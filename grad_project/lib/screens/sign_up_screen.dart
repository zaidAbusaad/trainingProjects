import 'package:flutter/material.dart';
import '../components/textfield.dart';
import '../firebase_functions/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  final AuthService _authService = AuthService();
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phonenumberController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Handy',
                style: TextStyle(
                    color: Color(0xFFFFDB58),
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 35),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Textfield(
                        textController: _usernameController,
                        hintText: 'Full Name',
                        validatitonText: 'Full Name Required',
                      ),
                      Textfield(
                        textController: _emailController,
                        hintText: 'Email',
                        validatitonText: 'Email Required',
                      ),
                      Textfield(
                        textController: _ageController,
                        hintText: 'Age',
                        validatitonText: 'Age Required',
                      ),
                      Textfield(
                        textController: _phonenumberController,
                        hintText: 'Phone Number',
                        validatitonText: 'Phone Number Required',
                      ),
                      Textfield(
                        textController: _passwordController,
                        hintText: 'Password',
                        validatitonText: 'Password Required',
                      ),
                      const SizedBox(height: 20),
                      ValueListenableBuilder<bool>(
                        valueListenable: _isLoading,
                        builder: (context, isLoading, child) {
                          return isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await _authService.fullSignUp(
                                  context: context,
                                  age: int.parse(_ageController.text),
                                  email: _emailController.text.trim(),
                                  formKey: _formKey,
                                  isLoading: _isLoading,
                                  name: _usernameController.text,
                                  password:
                                  _passwordController.text.trim(),
                                  phoneNumber:
                                  _phonenumberController.text,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize:
                              const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Create New Account',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          );
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Already have an account? Log In',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
