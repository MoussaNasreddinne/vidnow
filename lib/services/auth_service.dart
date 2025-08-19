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

  Future<void> updateUserProfile(
      {required String uid, required String username, String? newPassword}) async {
    try {
      await _firestore.collection('users').doc(uid).update({'username': username});
      if (newPassword != null && newPassword.isNotEmpty) {
        await currentUser?.updatePassword(newPassword);
      }

      CustomSnackbar.showSuccessCustomSnackbar(
        title: 'Success',
        message: 'Profile updated successfully!',
      );
    } on FirebaseAuthException catch (e) {
      CustomSnackbar.showErrorCustomSnackbar(
        title: 'Update Error',
        message: e.message ?? 'Could not update profile.',
      );
      rethrow;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
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
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('preferences')
              .doc('settings')
              .set({
            'is_dark_mode': true,
            'language_code': 'en',
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

  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        // Create a new document for the user with the uid
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'isPremium': false,
        });
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('preferences')
            .doc('settings')
            .set({
          'is_dark_mode': true,
          'language_code': 'en',
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

  // Helper to delete all documents in a given subcollection.
  Future<void> _deleteSubcollection(CollectionReference subcollectionRef) async {
    final snapshot = await subcollectionRef.get();
    if (snapshot.docs.isEmpty) return;
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    debugPrint('AuthService: Cleared subcollection at ${subcollectionRef.path}.');
  }

  // Deletes all user data from Firestore 
  Future<void> _deleteUserFirestoreData(String uid) async {
    final userDocRef = _firestore.collection('users').doc(uid);

    await _deleteSubcollection(userDocRef.collection('favorites'));
    await _deleteSubcollection(userDocRef.collection('watch_history'));
    await _deleteSubcollection(userDocRef.collection('preferences'));

    await userDocRef.delete();
    debugPrint('AuthService: Deleted user document and subcollections for user $uid.');
  }

  // Deletes all comments made by a user.
  Future<void> _deleteUserComments(String uid) async {
    final commentsSnapshot =
        await _firestore.collectionGroup('comments').where('userId', isEqualTo: uid).get();

    if (commentsSnapshot.docs.isNotEmpty) {
      final batch = _firestore.batch();
      for (final doc in commentsSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      debugPrint('AuthService: Deleted ${commentsSnapshot.docs.length} comments for user $uid.');
    }
  }

  // Main public method to delete a user account.
  Future<void> deleteUserAccount() async {
    final user = currentUser;
    if (user == null) {
      CustomSnackbar.showErrorCustomSnackbar(
          title: 'Error', message: 'No user is currently signed in.');
      return;
    }

    try {
      final uid = user.uid;
      await _deleteUserFirestoreData(uid);
      await _deleteUserComments(uid);
      await user.delete();

      await _googleSignIn.signOut();

      CustomSnackbar.showSuccessCustomSnackbar(
        title: 'Success'.tr,
        message: 'accountDeletedSuccess'.tr,
      );
      debugPrint('AuthService: Successfully deleted account for user $uid.');
    } on FirebaseAuthException catch (e) {
      debugPrint('AuthService: Error deleting account: ${e.message}');
      if (e.code == 'requires-recent-login') {
        CustomSnackbar.showErrorCustomSnackbar(
          title: 'Security Check',
          message: 'reauthenticationRequired'.tr,
        );
      } else {
        CustomSnackbar.showErrorCustomSnackbar(
          title: 'Error',
          message: e.message ?? 'Could not delete account.',
        );
      }
    } catch (e) {
      debugPrint('AuthService: An unexpected error occurred during account deletion: $e');
      CustomSnackbar.showErrorCustomSnackbar(
        title: 'Error',
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }
}