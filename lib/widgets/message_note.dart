import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MessageNote extends StatelessWidget {
  const MessageNote({
    super.key,
    required this.message,
    required this.onDelete,
  });
  final String message;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: ((context) => {}),
            icon: Icons.edit,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
          ),
          SlidableAction(
            onPressed: ((context) => onDelete()),
            icon: Icons.delete,
            backgroundColor: Colors.grey[300] ?? Colors.transparent,
            foregroundColor: Colors.red,
          ),
        ],
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        margin: EdgeInsets.only(
          top: 2,
          bottom: 2,
          right: 8,
          left: MediaQuery.of(context).size.width * 0.15,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
