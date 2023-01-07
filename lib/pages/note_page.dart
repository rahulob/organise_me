import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:organise_me/widgets/bottom_bar.dart';
import 'note_details_page.dart';

class NotePage extends StatefulWidget {
  const NotePage({
    super.key,
    required this.data,
    required this.index,
  });

  final String? index;
  final dynamic data;
  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final _messageController = TextEditingController();
  late final data = widget.data;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NoteDetailsPage(
                index: widget.index,
                data: widget.data,
              ),
            ),
          ),
          child: Text(data['title']),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: messageNotes(data['messages']),
              ),
            ),
            BottomBar(index: widget.index),
          ],
        ),
      ),
    );
  }
}

List<Widget> messageNotes(notes) {
  List<Widget> noteList = [];
  notes.forEach((key, value) {
    noteList.add(
      Text(value),
    );
  });
  return noteList;
}
