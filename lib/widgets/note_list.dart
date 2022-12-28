import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:learningdart/services/crud/notes.dart';
import 'package:learningdart/widgets/generic_dialog.dart';

typedef DeleteNoteCallback = void Function(DatabaseNote note);

class NotesList extends StatelessWidget {
  final List<DatabaseNote> notes;
  final DeleteNoteCallback onDeleteNote;

  const NotesList({super.key, required this.notes, required this.onDeleteNote});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            notes[index].text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: (() async {
              final shouldDelete = await showDeleteDialog(
                  context, "Are you sure to delete this item");
              if (shouldDelete!) onDeleteNote(notes[index]);
            }),
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}

Future<bool?> showDeleteDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete Note',
    content: text,
    optionsBuilder: () => {
      'Cancel': false,
      'Ok': true,
    },
  );
}
