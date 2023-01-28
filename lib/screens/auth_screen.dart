import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _registerUser = true;
  bool _showPassword = false;
  bool _isLoading = false;

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
              constraints: const BoxConstraints(maxWidth: 500),
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
                  FormInput(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'eg: email@example.com',
                  ),
                  FormInput(
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    label: 'Password',
                  ),
                  Visibility(
                    visible: _registerUser,
                    child: FormInput(
                      controller: _confirmPasswordController,
                      obscureText: !_showPassword,
                      label: 'Confirm Password',
                    ),
                  ),

                  // checkbox to show/hide password
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'Show Password',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 14),
                          ),
                          value: _showPassword,
                          onChanged: (_) => setState(() {
                            _showPassword = !_showPassword;
                          }),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      // TODO: Forgot password
                      Visibility(
                        visible: !_registerUser,
                        child: Align(
                          // alignment: Alignment.centerRight,
                          child: TextButton(
                            child: const Text(
                              'Forgot Password?',
                              textAlign: TextAlign.end,
                              style: TextStyle(),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  // Login Buttons
                  _isLoading
                      ? const CircularProgressIndicator()
                      : FilledButton(
                          style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(45)),
                          onPressed: _registerUser ? registerUser : signIn,
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                  _registerUser ? 'Register' : 'Sign In',
                                  style: const TextStyle(fontSize: 14),
                                ),
                        ),
                  const SizedBox(height: 20),
                  Row(
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
    setState(() {
      _isLoading = true;
    });
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    )
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      const SnackBar(content: Center(child: Text('Signed In')));
    }).catchError((_) {
      setState((() => _isLoading = false));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_),
      ));
    });
  }

  Future registerUser() async {
    if (_passwordController.text != _confirmPasswordController.text) return;
    // final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        )
        .then((value) => const SnackBar(
            content: Center(child: Text('New account created'))));
    // await FirebaseFirestore.instance.collection("notes").add(uid);
  }
}

class FormInput extends StatelessWidget {
  const FormInput({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.hint,
  });
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
