import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_auth/features/auth/controller/auth_controller.dart';

class EnterPasswordView extends ConsumerStatefulWidget {
  const EnterPasswordView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EnterPasswordViewState();
}

class _EnterPasswordViewState extends ConsumerState<EnterPasswordView> {
  late final TextEditingController passwordController;

  @override
  void initState() {
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          TextField(
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
          ),
          FilledButton(
              onPressed: () async {
                await ref
                    .read(authStateProvider.notifier)
                    .signIn(context, password: passwordController.text);
              },
              child: Text("Sign In"))
        ],
      ),
    );
  }
}
