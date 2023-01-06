import 'package:flutter/material.dart';
import '../widgets/my_drawer.dart';
import '../widgets/notes_grid.dart';
import 'note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _gridView = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () => setState(() => _gridView = !_gridView),
            icon: Icon(_gridView ? Icons.list : Icons.view_column),
          ),
          IconButton(
            onPressed: () => setState(() => _gridView = !_gridView),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: NotesGrid(gridView: _gridView),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const NotePage()),
              ),
          icon: const Icon(Icons.add),
          label: const Text('Add Note')),
    );
  }
}