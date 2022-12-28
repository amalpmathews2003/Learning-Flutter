import 'package:flutter/material.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/services/auth/exceptions.dart';
import 'package:learningdart/services/auth/service.dart';
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
      await AuthService.firebase().login(email: email, password: password);
    } on UserNotFoundAuthException {
      await showErrorDialog(context, 'User Not Found');
    } on WrongPasswordAuthException {
      await showErrorDialog(context, 'Wrong Password');
    } on GenericAuthException {
      await showErrorDialog(context, 'Unknown Error');
    }
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(noteRoute, (route) => false);
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
