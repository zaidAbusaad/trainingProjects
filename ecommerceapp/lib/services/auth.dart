import 'package:ecommerceapp/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerceapp/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create an AppUser object based on Firebase User
  AppUser? _userFromFirebaseUser(User? firebaseUser) {
    return firebaseUser != null ? AppUser(uid: firebaseUser.uid) : null;
  }

  // auth change user stream
  Stream<AppUser?> get firebaseUser {
    return _auth.authStateChanges().map((User? firebaseUser) => _userFromFirebaseUser(firebaseUser));
  }



  // Sign in with email and password
  Future signInWithEmailAndPassword( String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register with email and password and add user data to the database
  Future<AppUser?> registerWithEmailAndPassword(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // Adding user data to the database after successful registration
      if (user != null) {
        await DatabaseService(uid: user.uid).updateUserData(
          name, // You may replace this with an actual name if available
          email, // Store the registered email
        );
      }

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
