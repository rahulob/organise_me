import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageNote extends StatefulWidget {
  const MessageNote({
    super.key,
    required this.message,
    required this.onDelete,
    required this.onEdit,
    required this.createdAt,
  });
  final String message;
  final String createdAt;
  final Function() onDelete;
  final Function() onEdit;

  @override
  State<MessageNote> createState() => _MessageNoteState();
}

class _MessageNoteState extends State<MessageNote> {
  Offset _tapPosition = Offset.zero;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) =>
          setState(() => _tapPosition = details.globalPosition),
      onLongPress: () => showOptions(context),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Card(
            margin: const EdgeInsets.only(bottom: 4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.message,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${widget.createdAt.substring(0, 10)} ${widget.createdAt.substring(11, 16)}",
                    style: const TextStyle(
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showOptions(context) {
    return showMenu(
      context: context,
      position: RelativeRect.fromRect(
        _tapPosition & const Size(40, 40),
        Offset.zero & Size.infinite,
      ),
      items: [
        PopupMenuItem(
          onTap: widget.onEdit,
          child: const ListTile(
            leading: Icon(Icons.edit),
            title: Text("Edit"),
          ),
        ),
        PopupMenuItem(
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: widget.message)).then(
              (value) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(milliseconds: 500),
                  content: Text("Copied to the clipboard!"),
                ),
              ),
            );
          },
          child: const ListTile(
            leading: Icon(Icons.copy),
            title: Text("Copy"),
          ),
        ),
        PopupMenuItem(
          onTap: widget.onDelete,
          child: const ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text("Delete"),
          ),
        ),
      ],
    );
  }
}
