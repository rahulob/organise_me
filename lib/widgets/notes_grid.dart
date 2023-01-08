import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:organise_me/helper.dart';

import 'something_went_wrong.dart';
import 'note_tile.dart';

class NotesGrid extends StatelessWidget {
  NotesGrid({super.key, required this.gridView});
  final bool gridView;
  final _notesStream = FirebaseFirestore.instance
      .collection('notes')
      .doc("cwFz27aYho5irmdmtzoK")
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: _notesStream,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const SomethingWentWrong();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          final List<Widget> notelist = [];
          sortMapByKeys(data).forEach((key, value) {
            notelist.add(NoteTile(
              data: value,
              index: key,
            ));
          });
          return StaggeredGrid.count(
            crossAxisCount: gridView ? 2 : 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: notelist,
          );
        });
  }
}
