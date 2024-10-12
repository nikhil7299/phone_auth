import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_auth/features/user/user_state.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserState?>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserState?> {
  UserNotifier() : super(null);

  void setUser(UserState user) {
    state = user;
  }

  void removeUser() {
    state = null;
  }
}
