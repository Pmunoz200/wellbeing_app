import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      await _updateUserData(userCredential.user);
      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print("Error at the signIn with Google: $e");
      }
      throw ("Error at the signIn with Google");
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _updateUserData(userCredential.user);
      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw ("Error at the signIn with email and password: $e");
    }
  }

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _updateUserData(userCredential.user);
      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw ("Error at the register with email and password: $e");
    }
  }

  // Update user data in Firestore
  Future<void> _updateUserData(User? user) async {
    if (user != null) {
      final userDoc = _firestore.collection('users').doc(user.uid);
      final userSnapshot = await userDoc.get();
      if (!userSnapshot.exists) {
        await userDoc.set({
          'name': user.displayName ?? '',
          'email': user.email,
          'onboardingCompleted': false,
        });
      }
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw ("Error at sending password reset email: $e");
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // Auth state changes
  Stream<User?> get user {
    return _auth.authStateChanges();
  }
}
