import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  bool _registerUser = true;
  bool _showPassword = false;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organise Me'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  _registerUser
                      ? 'Create a new Account'
                      : 'Sign In to your Account',
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Text Inputs
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  onChanged: ((value) => setState(() => _email = value)),
                ),
                const SizedBox(height: 30),
                TextField(
                  obscureText: !_showPassword,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  onChanged: ((value) => setState(() => _password = value)),
                ),
                Visibility(
                  visible: _registerUser,
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      TextField(
                        obscureText: !_showPassword,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Confirm Password',
                        ),
                        onChanged: ((value) =>
                            setState(() => _confirmPassword = value)),
                      ),
                    ],
                  ),
                ),

                // checkbox to show/hide password
                const SizedBox(height: 15),
                CheckboxListTile(
                  title: const Text('Show Password'),
                  value: _showPassword,
                  onChanged: (_) => setState(() {
                    _showPassword = !_showPassword;
                  }),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 15),

                // Login Buttons
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(60)),
                  onPressed: _registerUser ? registerUser : signIn,
                  child: Text(
                    _registerUser ? 'Register' : 'Sign In',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                    onPressed: () =>
                        setState(() => _registerUser = !_registerUser),
                    child: Text(_registerUser
                        ? 'Already have an account? Sign In'
                        : 'New Here? Register now')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signIn() {}
  void registerUser() {}
}
