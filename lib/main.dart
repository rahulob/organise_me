import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:organise_me/preferences.dart';
import 'package:organise_me/theme_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organise Me',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).isDark
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
