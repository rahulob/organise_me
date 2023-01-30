import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:organise_me/helper.dart';
import 'package:organise_me/widgets/bottom_input.dart';
import '../widgets/message_note.dart';
import '../widgets/something_went_wrong.dart';
import 'note_details_page.dart';

class NotePage extends StatelessWidget {
  const NotePage({
    super.key,
    required this.data,
    required this.index,
  });

  final String? index;
  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NoteDetailsPage(
                index: index,
                data: data,
              ),
            ),
          ),
          child: Text(data['title']),
        ),
        actions: [
          IconButton(
            onPressed: () => deleteNote(context),
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
          child: NotePageBody(index: index),
        ),
      ),
    );
  }

  void deleteNote(context) async {
    final notesRef = FirebaseFirestore.instance
        .collection('notes')
        .doc("cwFz27aYho5irmdmtzoK");

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
                await notesRef.set(
                  {
                    index ?? '': FieldValue.delete(),
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
}

class NotePageBody extends StatefulWidget {
  const NotePageBody({super.key, this.index});

  final String? index;
  @override
  State<NotePageBody> createState() => _NotePageBodyState();
}

class _NotePageBodyState extends State<NotePageBody> {
  // These two properties are used to edit message notes
  String?
      _editMessageId; // used to send index of the message to update in the firestore
  String?
      _previousMessage; // used to display previous message over the bottom input

  final _bottomInputController = TextEditingController();
  bool? _iconsVisible;
  final _listController = ScrollController();
  final _notesRef = FirebaseFirestore.instance
      .collection('notes')
      .doc("cwFz27aYho5irmdmtzoK");

  // disposing the text controller
  @override
  void dispose() {
    _bottomInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  return const Center(
                    child: Text('There is nothing here. Try adding something!'),
                  );
                }

                final List<Widget> notelist = [];
                sortMapByKeys(data['messages']).forEach((key, value) {
                  notelist.add(
                    MessageNote(
                      createdAt: key,
                      message: value,
                      onDelete: () => deleteMessage(key),
                      onEdit: () => editMessage(key, value),
                    ),
                  );
                });
                return ListView(
                  controller: _listController,
                  children: notelist,
                );
              }),
        ),
        BottomInput(
          controller: _bottomInputController,
          messageId: _editMessageId,
          previousMessage: _previousMessage,
          index: widget.index,
          isIconsVisible: _iconsVisible,
          onAdded: () {
            if (_editMessageId != null) {
              setState(() {
                _editMessageId = null;
                _previousMessage = null;
                _iconsVisible = null;
              });
            } else {
              _listController.animateTo(
                _listController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
              );
            }
          },
        ),
      ],
    );
  }

  void deleteMessage(String index) async {
    await _notesRef.set({
      widget.index ?? '': {
        "messages": {index: FieldValue.delete()}
      }
    }, SetOptions(merge: true));
  }

  void editMessage(String index, String message) async {
    setState(() {
      _editMessageId = index;
      _bottomInputController.text = message;
      _previousMessage = message;
      _iconsVisible = false;
    });
  }
}
