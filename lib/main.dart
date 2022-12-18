import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/views/verify_email.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp2());
}

class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo by amal ',
      theme: ThemeData(),
      home: const HomePage(),
      routes: registeredRoutes(context),
      darkTheme: ThemeData.dark(useMaterial3: true),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    initializeFirebase().then(
      (success) {
        if (success) {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            if (user.emailVerified) {
              if (kDebugMode) {
                print('user email is verified');
              }
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(noteRoute, (route) => false);
            } else {
              if (kDebugMode) {
                print('user email is not verified');
              }
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const VerifyEmailView(),
                ),
              );
            }
          } else {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(loginRoute, (route) => false);
          }
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Home Page'),
            ),
            body: const CircularProgressIndicator(),
          );
        }
      },
    );
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.red,
      ),
    );
  }

  Future<bool> initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
