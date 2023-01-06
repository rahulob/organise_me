import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _registerUser = true;
  bool _showPassword = false;
  bool _error = false;

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
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    _registerUser
                        ? 'Good to see you! Create a new Account'
                        : 'Welcome Back! Sign In to your Account',
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // Text Inputs
                  TextInput(
                    controller: _emailController,
                    label: 'Email',
                  ),
                  TextInput(
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    label: 'Password',
                  ),
                  Visibility(
                    visible: _registerUser,
                    child: TextInput(
                      controller: _confirmPasswordController,
                      obscureText: !_showPassword,
                      label: 'Confirm Password',
                    ),
                  ),

                  // checkbox to show/hide password
                  // const SizedBox(height: 10),
                  CheckboxListTile(
                    title: const Text('Show Password'),
                    value: _showPassword,
                    onChanged: (_) => setState(() {
                      _showPassword = !_showPassword;
                    }),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 8),

                  // Login Buttons
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(45)),
                    onPressed: _registerUser ? registerUser : signIn,
                    child: Text(
                      _registerUser ? 'Register' : 'Sign In',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(!_registerUser
                          ? 'New Here?'
                          : 'Already Have an account?'),
                      TextButton(
                          onPressed: () =>
                              setState(() => _registerUser = !_registerUser),
                          child:
                              Text(_registerUser ? 'Sign In' : 'Register now')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        )
        .then((value) =>
            const SnackBar(content: Center(child: Text('Signed In'))));
  }

  Future registerUser() async {
    if (_passwordController.text != _confirmPasswordController.text) return;
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        )
        .then((value) => const SnackBar(
            content: Center(child: Text('New account created'))));
  }
}

class TextInput extends StatelessWidget {
  const TextInput({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
  });
  final TextEditingController controller;
  final String label;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
              blurRadius: 2,
              color: Colors.grey,
            )
          ]),
      child: TextFormField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          contentPadding: const EdgeInsetsDirectional.all(8),
        ),
      ),
    );
  }
}
