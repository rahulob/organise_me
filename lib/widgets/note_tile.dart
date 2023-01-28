import 'package:flutter/material.dart';
import '../screens/note_page.dart';

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
      child: Container(
        // shape: const OutlineInputBorder(),
        // elevation: 1,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[700] ?? Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['title'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
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
