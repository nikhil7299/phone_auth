import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_auth/features/auth/controller/auth_controller.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;
  @override
  void initState() {
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          TextField(
            decoration: const InputDecoration(hintText: 'Enter Phone Number'),
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            controller: phoneController,
            keyboardType: TextInputType.phone,
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'Enter Password'),
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
          ),
          FilledButton(
              onPressed: () async {
                await ref.read(authStateProvider.notifier).sendOtp(context,
                    phone: phoneController.text,
                    password: passwordController.text);
              },
              child: const Text('Send OTP'))
        ],
      ),
    );
  }
}
