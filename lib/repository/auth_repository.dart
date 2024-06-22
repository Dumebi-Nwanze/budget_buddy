import 'dart:convert';

import 'package:budget_buddy/main.dart';
import 'package:budget_buddy/models/user_model.dart';
import 'package:budget_buddy/utils/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<NetworkResponse> signUp(
      {required String email,
      required String password,
      required String fullname}) async {
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = UserModel(
        uid: userCred.user!.uid,
        displayName: fullname,
        email: email,
        income: 0.00,
        expenses: 0.00,
        categories: [],
        createdAt: DateTime.now(),
      );
      await _firestore
          .collection('users')
          .doc(userCred.user!.uid)
          .set(user.toJson());
      await sharedPrefs?.setString('user', jsonEncode(user.toJson()));
      return NetworkResponse(
        status: Status.success,
        message: 'Signup was successful',
        data: user,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return const NetworkResponse(
            status: Status.failed,
            message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return const NetworkResponse(
            status: Status.failed,
            message: 'The account already exists for that email.');
      } else {
        return NetworkResponse(status: Status.failed, message: e.message ?? "");
      }
    } catch (e) {
      return const NetworkResponse(
          status: Status.failed,
          message: "Something went wrong while creating an acccount");
    }
  }

  Future<NetworkResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot snap =
          await _firestore.collection('users').doc(userCred.user!.uid).get();

      final user = UserModel.fromSnapshot(snap);
      await sharedPrefs?.setString('user', jsonEncode(user.toJson()));

      return NetworkResponse(
        status: Status.success,
        message: 'Sign in successful, Welcome',
        data: user,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return const NetworkResponse(
            status: Status.failed,
            message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return const NetworkResponse(
            status: Status.failed,
            message: 'The account already exists for that email.');
      } else {
        return NetworkResponse(status: Status.failed, message: e.message ?? "");
      }
    } catch (e) {
      logger.d(e);
      return const NetworkResponse(
          status: Status.failed,
          message: "Something went wrong while logging in");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await sharedPrefs?.clear();
  }

  Future<NetworkResponse> forgotPassword({
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);

      return const NetworkResponse(
        status: Status.success,
        message: 'Password reset email sent. Please check your email.',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return const NetworkResponse(
          status: Status.failed,
          message: 'No user found with that email.',
        );
      } else {
        return NetworkResponse(status: Status.failed, message: e.message ?? "");
      }
    } catch (e) {
      return const NetworkResponse(
        status: Status.failed,
        message: 'Something went wrong. Please try again later.',
      );
    }
  }
}
