import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_auth/features/auth/controller/auth_controller.dart';

class ChangePasswordView extends ConsumerStatefulWidget {
  const ChangePasswordView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangePasswordViewState();
}

class _ChangePasswordViewState extends ConsumerState<ChangePasswordView> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Change Password'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          TextField(
            decoration: const InputDecoration(hintText: 'Current Password'),
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            controller: currentPasswordController,
            keyboardType: TextInputType.phone,
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'New Password'),
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            controller: newPasswordController,
            keyboardType: TextInputType.visiblePassword,
          ),
          FilledButton(
              onPressed: () async {
                await ref.read(authStateProvider.notifier).changePassword(
                      context,
                      currentPasswordController.text,
                      newPasswordController.text,
                    );
              },
              child: const Text('Submit')),
        ],
      ),
    );
  }
}
