import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_auth/features/auth/controller/auth_controller.dart';
import 'package:phone_auth/features/user/user_controller.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          FilledButton(
              onPressed: () async {
                await ref.read(authStateProvider.notifier).logOut();
              },
              child: Text("Logout")),
          FilledButton(
              onPressed: () async {
                print(ref.read(userProvider));
              },
              child: Text("Print User"))
        ],
      ),
    );
  }
}
