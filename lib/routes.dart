import 'package:flutter/material.dart';
import 'package:learningdart/views/login.dart';
import 'package:learningdart/views/register.dart';

Map<String, Widget Function(BuildContext)> registeredRoutes(
    BuildContext context) {
  return {
    '/login/': (context) => const LoginView(),
    '/register/': (context) => const RegisterView(),
  };
}
