import 'package:flutter/material.dart';

class MessageNote extends StatelessWidget {
  const MessageNote({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 4, right: 8),
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
    );
  }
}
