import 'package:flutter/material.dart';
import 'package:learningdart/views/google_auth.dart';
import 'package:learningdart/views/login.dart';
import 'package:learningdart/views/notes.dart';
import 'package:learningdart/views/register.dart';

Map<String, Widget Function(BuildContext)> registeredRoutes(
    BuildContext context) {
  return {
    '/login/': (context) => const LoginView(),
    '/register/': (context) => const RegisterView(),
    '/note/': (context) => const NoteView(),
    'OAuth': (context) => GoogleAuth(),
  };
}
