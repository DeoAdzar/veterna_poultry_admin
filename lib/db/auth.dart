import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/pages.dart';
import '../widget/show_snackbar.dart';
import 'notification_methods.dart';

//class ini buat ngumpulin fungsi dari firebase auth, dari login,register, sama logout.
// bakal dipanggil di beberapa layout yang butuh, nnti bakal ada ketambahan juga buat crud dari firestore

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      // ShowSnackbar.snackBarNormal('Login Successfully');
      // Get.offAllNamed(AppPages.HOME);
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get()
          .then(
        (DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists) {
            if (documentSnapshot.get('role') == "admin") {
              ShowSnackbar.snackBarNormal('Login Successfully');
              await NotificationsMethod.updateFirebaseMessagingToken();
              Get.offAllNamed(AppPages.HOME);
            } else {
              ShowSnackbar.snackBarError('You aren\'t registered');
              _firebaseAuth.signOut();
              Get.offAllNamed(AppPages.LOGIN);
            }
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      ShowSnackbar.snackBarError(e.message.toString());
    }
  }

  Future<void> resetPassword({
    required BuildContext context,
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      ShowSnackbar.snackBarSuccess('Sent Email Successfully');
      Get.offAllNamed(AppPages.LOGIN);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      ShowSnackbar.snackBarError(e.message.toString());
    }
  }

  Future<void> signOut({
    required BuildContext context,
  }) async {
    try {
      await _firebaseAuth.signOut();
      Get.offAllNamed(AppPages.LOGIN);
      ShowSnackbar.snackBarSuccess('Logout Succesfully');
    } on FirebaseAuthException catch (e) {
      ShowSnackbar.snackBarError(e.message.toString());
    }
  }
}
