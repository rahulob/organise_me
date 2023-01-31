import 'package:flutter/material.dart';
import 'package:organise_me/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // String? _themeValue = Preferences.getCurrentTheme();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Column(children: [
        const DarkThemeToggle(),
      ]),
    );
  }
}

class DarkThemeToggle extends StatelessWidget {
  const DarkThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text("Dark theme"),
      subtitle: Text(
        Provider.of<ThemeProvider>(context).isDark
            ? "Turn off to set the theme to light"
            : "Turn on to set the theme to dark",
      ),
      value: context.watch<ThemeProvider>().isDark,
      onChanged: (value) => context.read<ThemeProvider>().setdarkTheme(value),
    );
  }
}
