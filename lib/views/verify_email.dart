import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatelessWidget {
  VerifyEmailView({super.key});

  final user = FirebaseAuth.instance.currentUser;

  void sendVerificationEmail() async {
    try {
      await user?.sendEmailVerification();
      log('verification email send successfully');
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text(
              'We\'ve sent you an email verification. Please open it to verify your account'),
          const Text(
              'If you haven\'t received a verification email yet, Please press the button below'),
          Text('${user?.email}'),
          TextButton(
            onPressed: sendVerificationEmail,
            child: const Text('Send email verification'),
          )
        ],
      ),
    );
  }
}
