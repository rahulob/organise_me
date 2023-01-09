import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({
    super.key,
    this.index,
    this.onAdded,
  });

  final String? index;
  final Function()? onAdded;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late final _controller = TextEditingController();

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
        margin: const EdgeInsets.only(left: 8, right: 8),
        height: _iconsVisible ? 60 : 200,
        padding: const EdgeInsetsDirectional.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: _iconsVisible
                    ? null
                    : BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(25)),
                child: Row(
                  crossAxisAlignment: !_iconsVisible
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        autofocus: !_iconsVisible ? true : false,
                        controller: _controller,
                        onTap: () => setState(() {
                          _iconsVisible = false;
                        }),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          hintText: 'Write what\'s on your mind',
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
                            icon: const Icon(Icons.attach_file_outlined),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.camera_alt_rounded),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: !_iconsVisible,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => setState(() {
                      _controller.text = '';
                      _iconsVisible = true;
                    }),
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
    final key = getTimeString();
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
      });
      widget.onAdded!();
    });
  }
}
