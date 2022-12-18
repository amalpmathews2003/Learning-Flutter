import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learningdart/constants/routes.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          popupMenu(context, mounted),
        ],
      ),
      body: const Center(
        child: null,
      ),
    );
  }
}

enum MenuAction { logout }

Widget popupMenu(BuildContext context, bool mounted) {
  void handleSelect(MenuAction value) async {
    switch (value) {
      case MenuAction.logout:
        final shouldLogout = await showLogoutDialogue(context);
        if (shouldLogout) {
          await FirebaseAuth.instance.signOut();
          if (!mounted) return;
          Navigator.of(context)
              .pushNamedAndRemoveUntil(loginRoute, (route) => false);
        }
        break;
      default:
        break;
    }
  }

  return PopupMenuButton<MenuAction>(
    onSelected: handleSelect,
    itemBuilder: (context) {
      return const [
        PopupMenuItem(
          value: MenuAction.logout,
          child: Text('Log out'),
        ),
      ];
    },
  );
}

Future<bool> showLogoutDialogue(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are your sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Sign out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
