import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  bool _iconsVisible = true;
  final _noteController = TextEditingController();
  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomCenter,
      child: Container(
        margin: const EdgeInsets.all(8),
        height: _iconsVisible ? 60 : 300,
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
                        controller: _noteController,
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
                      _noteController.text = '';
                      _iconsVisible = true;
                    }),
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                  ),
                  IconButton(
                    onPressed: () {},
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
}
