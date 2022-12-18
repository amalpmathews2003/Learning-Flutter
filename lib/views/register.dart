import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/views/login.dart';
import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => RegisterViewState();
}

class RegisterViewState extends State<RegisterView> {
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

  bool checkCredentials(String email, String password) {
    return email.isNotEmpty &&
        password.isNotEmpty &&
        password.length > 8 &&
        email.contains('@') &&
        email.contains('.');
  }

  void handleButtonClick() async {
    final email = _email.text;
    final password = _password.text;
    if (!checkCredentials(email, password)) {
      if (kDebugMode) {
        print('credentials aren\'t verified');
      }
      return;
    }
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (kDebugMode) {
        print('User registered successfully');
        print(userCredential);
      }
      if (!mounted) return;
      Navigator.of(context)
          .pushNamedAndRemoveUntil(noteRoute, (route) => false);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        switch (e.code) {
          case 'email-already-in-us':
            print('email already registered');
            break;
          default:
            print('unknown auth exception ocurred');
        }
        print(e.code);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Login View'),
          )
        ],
      ),
    );
  }
}
