import 'package:flutter/material.dart';
import 'package:learningdart/widgets/popmenu.dart';

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
