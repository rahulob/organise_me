import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../helper.dart';

class BottomInput extends StatefulWidget {
  const BottomInput({
    super.key,
    this.index,
    this.onAdded,
    this.messageId,
    required this.controller,
    this.previousMessage,
  });

  // this will be present when we edit a certain note
  final String? messageId;
  final String? previousMessage;

  final String? index;
  final TextEditingController controller;
  final Function()? onAdded;

  @override
  State<BottomInput> createState() => _BottomInputState();
}

class _BottomInputState extends State<BottomInput> {
  // late final widget.controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _insertIconsVisible = true;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            PreviousMessage(message: widget.previousMessage),
            Row(
              children: [
                TextInput(
                  focusNode: _focusNode,
                  controller: widget.controller,
                  onChanged: (value) => {
                    if (value.isNotEmpty)
                      setState(() => _insertIconsVisible = false)
                    else
                      setState(() => _insertIconsVisible = true)
                  },
                ),
                Visibility(
                  visible: _insertIconsVisible,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.attach_file_outlined, size: 20),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.camera_alt_rounded, size: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Visibility(
              visible: !_insertIconsVisible,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.controller.text = '';
                        _insertIconsVisible = true;
                        widget.onAdded!();
                      });
                      widget.onAdded!();
                    },
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                  ),
                  IconButton(
                    onPressed: addNote,
                    icon: const Icon(Icons.save),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addNote() async {
    final ref = FirebaseFirestore.instance
        .collection("notes")
        .doc("cwFz27aYho5irmdmtzoK");
    final key = widget.messageId ?? getTimeString();
    final value = widget.controller.text.trim();
    await ref.set({
      widget.index ?? '': {
        "messages": {
          key: value,
        }
      }
    }, SetOptions(merge: true)).then((_) {
      setState(() {
        widget.controller.text = '';
        _insertIconsVisible = true;
      });
      widget.onAdded!();
    });
  }

  void updateMessage(String message) {
    setState(() {
      widget.controller.text = message;
    });
  }
}

class TextInput extends StatelessWidget {
  const TextInput({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onTapOutside,
    this.focusNode,
    this.autoFocus = false,
  });

  final TextEditingController controller;
  final void Function(String) onChanged;
  final void Function(PointerDownEvent)? onTapOutside;
  final FocusNode? focusNode;
  final bool autoFocus;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedSize(
        // curve: Curves.easeIn,
        duration: const Duration(milliseconds: 100),
        child: TextField(
          autofocus: autoFocus,
          onTapOutside: onTapOutside,
          focusNode: focusNode,
          onChanged: onChanged,
          controller: controller,
          maxLines: null,
          decoration: InputDecoration(
            hintText: "Write whats on your mind",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}

class PreviousMessage extends StatelessWidget {
  const PreviousMessage({super.key, required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: message != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Previous Message"),
          Container(
            margin: const EdgeInsets.only(top: 4, bottom: 12),
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(90, 238, 238, 238),
              borderRadius: BorderRadius.circular(4),
            ),
            width: double.infinity,
            child: Text(
              message ?? '',
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
