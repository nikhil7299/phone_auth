import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_auth/features/auth/controller/auth_result.dart';
import 'package:phone_auth/features/auth/views/enter_otp_view.dart';
import 'package:phone_auth/features/user/user_controller.dart';
import 'package:phone_auth/features/user/user_state.dart';

final authenticatorProvider = Provider<Authenticator>((ref) {
  return Authenticator(ref);
});

class Authenticator {
  final Ref ref;
  Authenticator(this.ref);
  FirebaseAuth auth = FirebaseAuth.instance;
  User? get currentUser => FirebaseAuth.instance.currentUser;
  String? get userId => currentUser?.uid;
  bool get isAlreadyLoggedIn => userId != null;
  String get displayName => currentUser?.displayName ?? '';
  String? get email => currentUser?.email;

  Future<AuthResult> sendOtp(BuildContext context, String phone) async {
    final sm = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (phoneAuthCredential) async {
          try {
            await auth.signInWithCredential(phoneAuthCredential);
          } on FirebaseAuthException catch (e) {
            sm.showSnackBar(
              SnackBar(
                content: Text(e.message.toString()),
              ),
            );
          }
        },
        verificationFailed: (error) {
          sm.showSnackBar(
            SnackBar(
              content: Text(error.message.toString()),
            ),
          );
        },
        codeSent: (verificationId, forceResendingToken) {
          print(verificationId);
          navigator.push(
            MaterialPageRoute(
              builder: (context) => EnterOtpView(verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
      return AuthResult.otpSent;
    } catch (e) {
      if (e is FirebaseAuthException) {
        sm.showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
          ),
        );
      }
      sm.showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      print(e.toString());
      return AuthResult.failure;
    }
  }

  Future<AuthResult> validateOtp(
      BuildContext context, String verificationId, String otp) async {
    final sm = ScaffoldMessenger.of(context);
    final phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);

    try {
      await auth.signInWithCredential(phoneAuthCredential);
      return AuthResult.otpValidated;
    } catch (e) {
      if (e is FirebaseAuthException) {
        sm.showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
          ),
        );
      }
      sm.showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      print(e.toString());
      return AuthResult.failure;
    }
  }

  Future<AuthResult> signIn(BuildContext context, String pasword) async {
    final sm = ScaffoldMessenger.of(context);
    final db = FirebaseFirestore.instance;

    try {
      final driverDoc = await db
          .collection('Driver')
          .where('PhoneNumber', isEqualTo: currentUser?.phoneNumber)
          .limit(1)
          .get();
      if (driverDoc.docs.isEmpty) {
        sm.showSnackBar(const SnackBar(
            content: Text("User with this phone doesn't exists")));
        return AuthResult.failure;
      }
      if (driverDoc.docs.first.data()['Password'] == pasword) {
        ref
            .read(userProvider.notifier)
            .setUser(UserState.fromMap(driverDoc.docs.first.data()));
        sm.showSnackBar(
            const SnackBar(content: Text('User Logged in Successfully')));

        return AuthResult.success;
      }
      sm.showSnackBar(const SnackBar(content: Text('Password does not match')));
      return AuthResult.failure;
    } catch (e) {
      if (e is FirebaseAuthException) {
        sm.showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
          ),
        );
      }
      sm.showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      print(e.toString());
      return AuthResult.failure;
    }
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
