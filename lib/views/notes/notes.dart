import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/services/auth/service.dart';
import 'package:learningdart/services/crud/notes.dart';
import 'package:learningdart/widgets/note_list.dart';
import 'package:learningdart/widgets/popmenu.dart' show popupMenu;

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  String get userEmail => AuthService.firebase().currentUser!.email!;
  late final NoteService _noteService;
  @override
  void initState() {
    _noteService = NoteService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
              icon: const Icon(Icons.add)),
          popupMenu(context, mounted),
        ],
      ),
      body: FutureBuilder(
        future: _noteService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _noteService.allNotes,
                builder: ((context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data!;
                        allNotes
                            .sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
                        return NotesList(
                          notes: allNotes,
                          onDeleteNote: ((note) async {
                            await _noteService.deleteNote(id: note.id);
                          }),
                          onTap: (note) {
                            Navigator.of(context).pushNamed(
                              createOrUpdateNoteRoute,
                              arguments: note,
                            );
                          },
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    default:
                      return const CircularProgressIndicator();
                  }
                }),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
