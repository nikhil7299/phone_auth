import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_auth/features/auth/controller/auth_result.dart';
import 'package:phone_auth/features/auth/controller/auth_state.dart';
import 'package:phone_auth/features/auth/controller/authenticator.dart';
import 'package:phone_auth/features/auth/views/enter_password_view.dart';

final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.result == AuthResult.success;
});

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ref);
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  Authenticator? _authenticator;

  AuthStateNotifier(this.ref) : super(const AuthState.unknown()) {
    _authenticator = ref.watch(authenticatorProvider);
    if (_authenticator!.isAlreadyLoggedIn) {
      state = AuthState(
        result: AuthResult.success,
        isLoading: false,
        userId: _authenticator!.userId,
      );
    }
  }

  Future<void> sendOtp(BuildContext context, {required String phone}) async {
    final sm = ScaffoldMessenger.of(context);
    state = state.copiedWithIsLoading(true);
    final db = FirebaseFirestore.instance;
    final driverDoc = await db
        .collection('Driver')
        .where('PhoneNumber', isEqualTo: phone)
        .limit(1)
        .get();
    if (driverDoc.docs.isEmpty) {
      sm.showSnackBar(
          const SnackBar(content: Text("User with this phone doesn't exists")));
      state = const AuthState(
          result: AuthResult.failure, isLoading: false, userId: null);

      return;
    }

    final result = await _authenticator!.sendOtp(context, phone);

    state = AuthState(result: result, isLoading: false, userId: null);
  }

  Future<void> validateOtp(
    BuildContext context, {
    required String verificationId,
    required String otp,
  }) async {
    state = state.copiedWithIsLoading(true);
    final result =
        await _authenticator!.validateOtp(context, verificationId, otp);
    if (result == AuthResult.otpValidated) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnterPasswordView(),
          ));
      state = const AuthState(
          result: AuthResult.otpValidated, isLoading: false, userId: null);
      return;
    }
    state = const AuthState(
        result: AuthResult.failure, isLoading: false, userId: null);
  }

  Future<void> signIn(BuildContext context, {required String password}) async {
    state = state.copiedWithIsLoading(true);
    final result = await _authenticator!.signIn(context, password);
    if (result == AuthResult.success) {
      Navigator.pop(context);
      Navigator.pop(context);
      state = AuthState(
          result: AuthResult.success,
          isLoading: false,
          userId: _authenticator!.userId);
      return;
    }
    state = const AuthState(
        result: AuthResult.failure, isLoading: false, userId: null);
  }

  Future<void> logOut() async {
    state = state.copiedWithIsLoading(true);
    await _authenticator!.logOut();
    state = const AuthState.unknown();
  }
}
