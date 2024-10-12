import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_auth/features/auth/controller/auth_controller.dart';

class EnterOtpView extends ConsumerStatefulWidget {
  final String verificationId;
  const EnterOtpView(this.verificationId, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EnterOtpViewState();
}

class _EnterOtpViewState extends ConsumerState<EnterOtpView> {
  late final TextEditingController otpComtroller;

  @override
  void initState() {
    otpComtroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    otpComtroller.dispose();
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
            controller: otpComtroller,
            keyboardType: TextInputType.phone,
          ),
          FilledButton(
              onPressed: () async {
                await ref.read(authStateProvider.notifier).validateOtp(context,
                    verificationId: widget.verificationId,
                    otp: otpComtroller.text);
              },
              child: Text("Validate OTP"))
        ],
      ),
    );
  }
}
