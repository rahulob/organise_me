import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../helper.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({
    super.key,
    this.index,
    this.onAdded,
    this.messageId,
    this.message,
  });

  // this will be present when we edit a certain note
  final String? messageId;
  final String? message;

  final String? index;
  final Function()? onAdded;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _iconsVisible = true;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomCenter,
      child: Container(
        height: _iconsVisible ? 60 : 200,
        padding: const EdgeInsetsDirectional.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey[700] ?? Colors.grey),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: !_iconsVisible
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: _focusNode,
                      autofocus: !_iconsVisible ? true : false,
                      controller: _controller,
                      onTap: () => setState(() {
                        _iconsVisible = false;
                      }),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        hintText:
                            widget.message ?? 'Write what\'s on your mind',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                  ),
                  Visibility(
                    visible: _iconsVisible,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon:
                              const Icon(Icons.attach_file_outlined, size: 20),
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
            ),
            Visibility(
              visible: !_iconsVisible,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _controller.text = '';
                        _iconsVisible = true;
                        _focusNode.unfocus();
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
            )
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
    final value = _controller.text.trim();
    await ref.set({
      widget.index ?? '': {
        "messages": {
          key: value,
        }
      }
    }, SetOptions(merge: true)).then((_) {
      setState(() {
        _controller.text = '';
        _iconsVisible = true;
      });
      widget.onAdded!();
    });
  }
}
