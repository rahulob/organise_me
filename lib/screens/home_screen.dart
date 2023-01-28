import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organise_me/screens/auth_screen.dart';
import 'package:provider/provider.dart';
import '../widgets/my_drawer.dart';
import '../widgets/notes_grid.dart';
import 'note_details_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _gridView = false;
  @override
  Widget build(BuildContext context) {
    // Check if user is signed in?
    if (Provider.of<User?>(context)?.uid == null) {
      return const AuthScreen();
    }

    // home screen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: () => setState(() => _gridView = !_gridView),
            icon: Icon(_gridView ? Icons.list : Icons.view_column),
          )
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
                MaterialPageRoute(
                  builder: (context) => const NoteDetailsPage(
                    newNote: true,
                    data: {},
                    index: '',
                  ),
                ),
              ),
          icon: const Icon(Icons.add),
          label: const Text('Add Note')),
    );
  }
}
