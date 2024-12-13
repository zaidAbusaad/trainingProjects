import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up function
  Future<UserCredential?> signUp(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      if (e.code == 'weak-password') {
        throw Exception('The password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('This email is already in use.');
      }
      throw Exception('Failed to sign up: ${e.message}');
    }
  }

}
