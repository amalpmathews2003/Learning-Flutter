import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/widgets/generic_dialog.dart';

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
              .pushNamedAndRemoveUntil(loginRoute, (_) => false);
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
  return showGenericDialog<bool>(
      context: context,
      title: 'Log out',
      content: 'Are you sure you want to log out?',
      optionsBuilder: () => {
            'Cancel': false,
            'Log out': true,
          }).then((value) => value ?? false);
}
