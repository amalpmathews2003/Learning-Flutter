import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

/*
todo:
  adding SHA to firebase and make it working

*/
class GoogleAuthBtn extends StatefulWidget {
  const GoogleAuthBtn({super.key});

  @override
  State<GoogleAuthBtn> createState() => _GoogleAuthBtnState();
}

class _GoogleAuthBtnState extends State<GoogleAuthBtn> {
  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      final user = await FirebaseAuth.instance.signInWithCredential(credential);
      if (kDebugMode) {
        print(user);
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: signInWithGoogle, child: const Text('Sign in with google'));
  }
}
