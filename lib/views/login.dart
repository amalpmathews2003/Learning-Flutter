import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/widgets/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController(text: 'amalpmathews2003@gmail.com');
    _password = TextEditingController(text: 'Am@190603');
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void handleButtonClick() async {
    final email = _email.text;

    final password = _password.text;

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (!mounted) return;
      Navigator.of(context)
          .pushNamedAndRemoveUntil(noteRoute, (route) => false);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          await showErrorDialog(context, 'User not found');
          break;
        case 'wrong-password':
          await showErrorDialog(context, 'Wrong credentials');
          break;
        default:
          await showErrorDialog(context, 'Error : ${e.code}');
      }
    } catch (e) {
      log('unknown error occurred', name: 'login', error: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Enter your email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'Enter your password here'),
          ),
          TextButton(
            onPressed: handleButtonClick,
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Not registered yet? Register here'),
          )
        ],
      ),
    );
  }
}
