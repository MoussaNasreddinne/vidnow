import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/widgets/snackbar.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/controllers/login_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  User? get currentUser => _firebaseAuth.currentUser;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      return userCredential.user;
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
        print('fields cleared');
      }
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      CustomSnackbar.showErrorCustomSnackbar(
        title: 'Sign-Out Error',
        message: e.message ?? 'An unknown error occurred during sign-out.',
      );
    }
  }
}