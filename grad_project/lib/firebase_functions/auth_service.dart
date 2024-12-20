import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../screens/log_in_screen.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up function for Firebase Authentication
  Future<UserCredential?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('This email is already in use.');
      }
      throw Exception('Failed to sign up: ${e.message}');
    }
  }

  // Save user details to UserModel
  UserModel _saveToModel({
    required String name,
    required String email,
    required int age,
    required String phoneNumber,
    required String password,
  }) {
    return UserModel(
      name: name,
      email: email,
      age: age,
      phoneNumber: phoneNumber,
      password: password,
    );
  }

  // Full sign-up process with navigation
  Future<void> fullSignUp({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required int age,
    required String phoneNumber,
    required GlobalKey<FormState> formKey,
    required ValueNotifier<bool> isLoading,
  }) async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true; // Start loading
    }
      try {
        await signUp(email: email, password: password);


        // Save user data to the model
        final userModel = _saveToModel(
          name: name,
          email: email,
          age: age,
          phoneNumber: phoneNumber,
          password: password,
        );

        print("User Created: Name - ${userModel.name}, Email - ${userModel.email}");

        await FirebaseFirestore.instance.collection('customers').add({
          'name': name,
          'email': email,
          'age': age,
          'phoneNumber': phoneNumber,
          'createdAt': DateTime.now(),
        });

        print("User data saved to Firestore");

        // Navigate to Login Screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LogInScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        isLoading.value = false; // Stop loading
      }

  }
}
