import 'package:flutter/material.dart';
import 'package:learningdart/views/google_auth.dart';
import 'package:learningdart/views/login.dart';
import 'package:learningdart/views/notes.dart';
import 'package:learningdart/views/register.dart';
import 'package:learningdart/views/verify_email.dart';

const loginRoute = '/login/';
const registerRoute = '/register/';
const noteRoute = '/notes/';
const verifyEmailRoute = '/verify-email/';

Map<String, Widget Function(BuildContext)> registeredRoutes(
    BuildContext context) {
  return {
    loginRoute: (context) => const LoginView(),
    registerRoute: (context) => const RegisterView(),
    noteRoute: (context) => const NoteView(),
    verifyEmailRoute: (context) => VerifyEmailView(),
    '/OAuth/': (context) => GoogleAuth(),
  };
}
