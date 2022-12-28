import 'package:flutter/material.dart';
import 'package:learningdart/views/google_auth.dart';
import 'package:learningdart/views/login.dart';
import 'package:learningdart/views/notes/create_update_note.dart';
import 'package:learningdart/views/notes/notes.dart';
import 'package:learningdart/views/register.dart';
import 'package:learningdart/views/verify_email.dart';

const loginRoute = '/login/';
const registerRoute = '/register/';
const oAuthRoute = '/OAuth/';
const verifyEmailRoute = '/verify-email/';
const noteRoute = '/notes/';
const createOrUpdateNoteRoute = '/notes/new';

Map<String, Widget Function(BuildContext)> registeredRoutes(
    BuildContext context) {
  return {
    loginRoute: (context) => const LoginView(),
    registerRoute: (context) => const RegisterView(),
    verifyEmailRoute: (context) => VerifyEmailView(),
    oAuthRoute: (context) => GoogleAuth(),
    noteRoute: (context) => const NoteView(),
    createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
  };
}
