import 'package:flutter/material.dart';
import '../pages/note_page.dart';

class NoteTile extends StatelessWidget {
  const NoteTile({
    super.key,
    required this.data,
    required this.index,
  });

  final String? index;
  final dynamic data;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => NotePage(
            index: index,
            data: data,
          ),
        ),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 8),
              Text(
                data['title'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                data['description'],
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
