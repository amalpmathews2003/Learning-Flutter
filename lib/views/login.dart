import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (kDebugMode) {
        print('used logged in successfully');
        print(userCredential);
      }
      Navigator.of(context).pushNamedAndRemoveUntil('/note/', (route) => false);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        switch (e.code) {
          case 'user-note-found':
            print('user not found');
            break;
          case 'wrong-password':
            print('wrong password');
            break;
          default:
            print('unknown auth exception ocurred');
        }
        print(e.code);
      }
    } catch (e) {
      if (kDebugMode) {
        print('unknown error occurred');
      }
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
                  .pushNamedAndRemoveUntil('/register/', (route) => false);
            },
            child: const Text('Not registered yet? Register here'),
          )
        ],
      ),
    );
  }
}
