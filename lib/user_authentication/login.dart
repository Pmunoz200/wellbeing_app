import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gemini_folder/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigator;
  const LoginScreen({required this.navigator, super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                User? user = await _authService.signInWithEmailAndPassword(
                  _emailController.text,
                  _passwordController.text,
                );
                if (user != null) {
                  widget.navigator.currentState?.pushReplacementNamed('/token');
                }
              },
              child: const Text('Login with Email'),
            ),
            ElevatedButton(
              onPressed: () async {
                User? user = await _authService.signInWithGoogle();
                if (user != null) {
                  widget.navigator.currentState?.pushReplacementNamed('/token');
                }
              },
              child: const Text('Login with Google'),
            ),
            ElevatedButton(
              onPressed: () async {
                User? user = await _authService.registerWithEmailAndPassword(
                  _emailController.text,
                  _passwordController.text,
                );
                if (user != null) {
                  widget.navigator.currentState?.pushReplacementNamed('/token');
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
