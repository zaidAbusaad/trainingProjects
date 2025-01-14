import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

import '../screens/log_in_screen.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create an AppUser object based on Firebase User
  UserModel? _userFromFirebaseUser(User? firebaseUser) {
    return firebaseUser != null ? UserModel(uid: firebaseUser.uid) : null;
  }

  // auth change user stream
  Stream<UserModel?> get firebaseUser {
    return _auth
        .authStateChanges()
        .map((User? firebaseUser) => _userFromFirebaseUser(firebaseUser));
  }

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
      uid: '',
    );
  }

  // Full sign-up process for customers
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
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if (user != null) {
        await DatabaseService(uid: user.uid).updateUserData(
          name, // You may replace this with an actual name if available
          email, // Store the registered email
          age,
          phoneNumber,
        );
      }

      // Save user data to the model
      final userModel = _saveToModel(
        name: name,
        email: email,
        age: age,
        phoneNumber: phoneNumber,
        password: password,
      );

      print(
          "User Created: Name - ${userModel.name}, Email - ${userModel.email}");

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

  // Full sign-up process for workers
  Future<void> fullSignUpWorker({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required int age,
    required String phoneNumber,
    required List<String> professions,
    required GlobalKey<FormState> formKey,
    required ValueNotifier<bool> isLoading,
  }) async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true; // Start loading
    }
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if (user != null) {
        // Save worker data to Firestore
        await FirebaseFirestore.instance.collection('workers').doc(user.uid).set({
          'name': name,
          'email': email,
          'age': age,
          'phoneNumber': phoneNumber,
          'professions': professions,
        });
      }

      print("Worker Created: Name - $name, Professions - $professions");

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
