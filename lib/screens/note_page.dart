import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:organise_me/helper.dart';
import 'package:organise_me/widgets/bottom_bar.dart';
import '../widgets/message_note.dart';
import '../widgets/something_went_wrong.dart';
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
  late final data = widget.data;
  final _listController = ScrollController();
  final _messageInputController = TextEditingController();

  final _notesRef = FirebaseFirestore.instance
      .collection('notes')
      .doc("cwFz27aYho5irmdmtzoK");
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
        actions: [
          IconButton(
            onPressed: deleteNote,
            icon: Icon(
              Icons.delete,
              color: Colors.red[600],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                    stream: _notesRef.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const SomethingWentWrong();
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      data = data[widget.index] ?? {};
                      if (data.isEmpty || data['messages'].isEmpty) {
                        return const Text(
                            'There is nothing here. Try adding some ideas!');
                      }

                      final List<Widget> notelist = [];
                      sortMapByKeys(data['messages']).forEach((key, value) {
                        notelist.add(MessageNote(
                          createdAt: key,
                          message: value,
                          onDelete: () => deleteMessage(key),
                          onEdit: () => editMessage(key),
                        ));
                      });
                      return ListView(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        controller: _listController,
                        children: notelist,
                      );
                    }),
              ),
              BottomBar(
                controller: _messageInputController,
                index: widget.index,
                onAdded: () => _listController
                    .jumpTo(_listController.position.maxScrollExtent),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteNote() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text(
              'Are you sure, you want to delete this note? It could not be restored later!'),
          actions: <Widget>[
            TextButton(
                child: const Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: const Text(
                'YES',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.pop(context);
                await _notesRef.set(
                  {
                    widget.index ?? '': FieldValue.delete(),
                  },
                  SetOptions(merge: true),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void deleteMessage(String index) async {
    await _notesRef.set({
      widget.index ?? '': {
        "messages": {index: FieldValue.delete()}
      }
    }, SetOptions(merge: true));
  }

  void editMessage(String index) async {
    //TODO
  }
}
