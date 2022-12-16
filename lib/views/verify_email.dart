import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final user = FirebaseAuth.instance.currentUser;
  void sendVerificationEmail() async {
    try {
      print('${user?.email} ${user?.emailVerified}');
      
      await user?.sendEmailVerification();
      if (kDebugMode) {
        print('verification email send successfully');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
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
          const Text('Please verify your email'),
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
