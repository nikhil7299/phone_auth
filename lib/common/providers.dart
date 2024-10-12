import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_auth/features/auth/controller/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.isLoading;
});

final prefsProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());
