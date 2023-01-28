import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MessageNote extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.4,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: ((context) => onEdit()),
            icon: Icons.edit,
            backgroundColor: Colors.transparent,
            // foregroundColor: Colors.black,
          ),
          SlidableAction(
            onPressed: ((context) => onDelete()),
            icon: Icons.delete,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.red,
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          // width: MediaQuery.of(context).size.width,
          // padding: const EdgeInsets.all(8),
          margin: EdgeInsets.only(
            // bottom: 4,
            left: MediaQuery.of(context).size.width * 0.1,
          ),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(10),
          // ),
          child: Card(
            margin: const EdgeInsets.only(bottom: 4),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${createdAt.substring(0, 10)}  ${createdAt.substring(11, 16)}",
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
}
