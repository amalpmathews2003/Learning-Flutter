import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

class GoogleAuth extends StatelessWidget {
  GoogleAuth({super.key});
  final providers = [EmailAuthProvider()];
  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: providers,
    );
  }
}
