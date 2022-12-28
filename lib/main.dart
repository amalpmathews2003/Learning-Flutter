import 'package:flutter/material.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/services/auth/service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp2());
}

class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo by amal',
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
  Widget build(BuildContext context, [bool mounted = true]) {
    initializeFirebase().then(
      (success) async {
        if (success) {
          final user = AuthService.firebase().currentUser;
          if (user != null) {
            if (user.isEmailVerified) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(noteRoute, (route) => false);
            } else {
              await AuthService.firebase().sendEmailVerification();
              if (!mounted) return null;
              Navigator.of(context).pushNamed('/verified-route/');
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
            body: const CircularProgressIndicator(
              color: Colors.green,
            ),
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
      await AuthService.firebase().initialize();
      return true;
    } catch (e) {
      return false;
    }
  }
}
