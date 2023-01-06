import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../something_went_wrong.dart';
import 'note_tile.dart';

class NotesGrid extends StatelessWidget {
  NotesGrid({super.key, required this.gridView});
  final bool gridView;
  final notes = FirebaseFirestore.instance.collection('notes');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: notes.doc('cwFz27aYho5irmdmtzoK').get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const SomethingWentWrong();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            final List<Widget> notelist = [];
            data.forEach((key, value) => notelist.add(
                  NoteTile(
                    title: value['title'],
                    description: value['description'],
                  ),
                ));
            return StaggeredGrid.count(
              crossAxisCount: gridView ? 2 : 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: notelist,
            );
          }

          return const Center(child: CircularProgressIndicator());
        });
  }
}
