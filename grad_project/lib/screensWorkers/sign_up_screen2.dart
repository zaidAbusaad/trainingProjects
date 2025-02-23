import 'package:flutter/material.dart';
import '../components/cutom_shapes/textfield.dart';
import '../components/cutom_shapes/toggle_button.dart';
import '../firebase_functions/auth_service.dart';

import '../screensCutomers/sign_up_screen.dart';

class SignUpScreen2 extends StatefulWidget {
  @override
  State<SignUpScreen2> createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  final AuthService _authService = AuthService();
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  // Professions
  final List<String> professions = [
    'Cleaner',
    'Electrician',
    'Plumber',
    'Painter',
    'AC Technician',
    'Renovator'
  ];
  final List<String> selectedProfessions = [];

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
              const SizedBox(height: 70),
              const Text(
                'Handy',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              ToggleButton(
                isCustomerSelected: false,
                onCustomerSelected: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                onWorkerSelected: () {},
              ),
              const SizedBox(height: 15),
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

                      // Profession Selection
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Select Your Professions:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        children: professions.map((profession) {
                          return FilterChip(
                            label: Text(profession),
                            selected: selectedProfessions.contains(profession),
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  selectedProfessions.add(profession);
                                } else {
                                  selectedProfessions.remove(profession);
                                }
                              });
                            },
                          );
                        }).toList(),
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
                                await _authService.fullSignUpWorker(
                                  context: context,
                                  age: int.parse(_ageController.text),
                                  email: _emailController.text.trim(),
                                  name: _usernameController.text,
                                  phoneNumber: _phonenumberController.text,
                                  password: _passwordController.text.trim(),
                                  professions: selectedProfessions,
                                  formKey: _formKey,
                                  isLoading: _isLoading,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Create New Account',
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          );
                        },
                      ),
                      const Divider(),
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
