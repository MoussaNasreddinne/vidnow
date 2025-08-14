import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/widgets/snackbar.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/controllers/login_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  User? get currentUser => _firebaseAuth.currentUser;


    Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      debugPrint('AuthService: Error fetching user profile: $e');
      return null;
    }
  }


 Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = 
          await _firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        
        if (!doc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'username': user.displayName ?? 'Google User',
            'email': user.email,
            'createdAt': FieldValue.serverTimestamp(),
            'isPremium': false,
            'photoUrl': user.photoURL,
          });
        }
      }

      return user;
    } on FirebaseAuthException catch (e) {
      CustomSnackbar.showErrorCustomSnackbar(
        title: 'Google Sign-In Error',
        message: e.message ?? 'An unknown error occurred during Google sign-in.',
      );
      return null;
    } catch (e) {
      CustomSnackbar.showErrorCustomSnackbar(
        title: 'Google Sign-In Error',
        message: 'An unknown error occurred during Google sign-in.',
      );
      return null;
    }
  }


Future<User?> signUpWithEmailAndPassword(String email, String password, String username) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'isPremium': false,
        });
      }
      return user;
    } on FirebaseAuthException catch (e) {
      CustomSnackbar.showErrorCustomSnackbar(
        title: 'Sign-Up Error',
        message: e.message ?? 'An unknown error occured during sign-up.',
      );
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      CustomSnackbar.showErrorCustomSnackbar(
        title: 'Sign-In Error',
        message: e.message ?? 'An unknown error occured during sign-in.',
      );
      return null;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      CustomSnackbar.showSuccessCustomSnackbar(
        title: 'Success',
        message: 'A password reset link has been sent to your email.',
      );
    } on FirebaseAuthException catch (e) {
      CustomSnackbar.showErrorCustomSnackbar(
        title: 'Error',
        message: e.message ?? 'Could not send password reset email.',
      );
    }
  }

  Future<void> signOut() async {
    try {
      if (locator.isRegistered<LoginController>()) {
        locator<LoginController>().clearFields();
      }
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      print('sign out success');
      
    } on FirebaseAuthException catch (e) {
      CustomSnackbar.showErrorCustomSnackbar(
        title: 'Sign-Out Error',
        message: e.message ?? 'An unknown error occurred during sign-out.',
      );
    }
  }
}

