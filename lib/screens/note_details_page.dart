import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:organise_me/helper.dart';

class NoteDetailsPage extends StatefulWidget {
  const NoteDetailsPage({
    super.key,
    this.newNote = false,
    required this.data,
    required this.index,
  });

  final bool newNote;
  final String? index;
  final dynamic data;
  @override
  State<NoteDetailsPage> createState() => _NoteDetailsPageState();
}

class _NoteDetailsPageState extends State<NoteDetailsPage> {
  late final data = widget.data;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    _titleController.text = data['title'] ?? '';
    _descriptionController.text = data['description'] ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                decoration: const InputDecoration(
                  hintText: 'Untitled',
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
                maxLines: null,
              ),
              const SizedBox(height: 10),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: null,
                minLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Description',
                ),
              ),
              const SizedBox(height: 10),

              // Buttons to save or cancel
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(widget.newNote ? 'Cancel' : 'Update'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: widget.newNote ? createNote : saveNote,
                    child: Text(widget.newNote ? 'Create Note' : 'Update'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createNote() async {
    String noteIndex = getTimeString();
    String title = 'Untitled';

    if (_titleController.text != '') {
      title = _titleController.text.trim();
    }
    final ref = FirebaseFirestore.instance
        .collection("notes")
        .doc("cwFz27aYho5irmdmtzoK");
    await ref.set({
      noteIndex: {
        'title': title,
        'description': _descriptionController.text.trim(),
        'messages': {},
      },
    }, SetOptions(merge: true)).then((_) {
      Navigator.pop(context);
    });
  }

  void saveNote() async {
    final ref = FirebaseFirestore.instance
        .collection("notes")
        .doc("cwFz27aYho5irmdmtzoK");
    await ref.set({
      widget.index ?? '': {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
      },
    }, SetOptions(merge: true)).then((_) {
      Navigator.pop(context);
    });
  }
}
