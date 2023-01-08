import 'package:flutter/material.dart';
import 'package:organise_me/helper.dart';
import 'package:organise_me/widgets/bottom_bar.dart';
import '../widgets/message_note.dart';
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
              child: ListView(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.15),
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

List<Widget> messageNotes(Map notes) {
  List<Widget> noteList = [];
  sortMapByKeys(notes).forEach((key, value) {
    noteList.add(
      MessageNote(message: value),
    );
  });
  return noteList;
}
