import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gemini_folder/services/auth_service.dart';
import 'package:gemini_folder/util/error_util.dart';

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

  bool _validateInputs() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegExp.hasMatch(email)) {
      showErrorToast('Please enter a valid email address.');
      return false;
    }

    if (password.length < 6) {
      showErrorToast('Password must be at least 6 characters long.');
      return false;
    }

    return true;
  }

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
                if (_validateInputs()) {
                  try {
                    User? user = await _authService.signInWithEmailAndPassword(
                      _emailController.text,
                      _passwordController.text,
                    );
                    if (user != null) {
                      widget.navigator.currentState
                          ?.pushReplacementNamed('/token');
                    } else {
                      showErrorToast('Login failed. Please try again.');
                    }
                  } catch (e) {
                    if (kDebugMode) {
                      print("Error at the Login: $e");
                    }
                    showErrorToast(e.toString());
                  }
                }
              },
              child: const Text('Login with Email'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  User? user = await _authService.signInWithGoogle();
                  if (user != null) {
                    if (kDebugMode) {
                      print("USER: $user");
                    }
                    widget.navigator.currentState
                        ?.pushReplacementNamed('/token');
                  } else {
                    showErrorToast('Google sign-in failed. Please try again.');
                  }
                } catch (e) {
                  if (kDebugMode) {
                    print("Error at the Login with Google: $e");
                  }
                  showErrorToast(e.toString());
                }
              },
              child: const Text('Login with Google'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_validateInputs()) {
                  try {
                    User? user =
                        await _authService.registerWithEmailAndPassword(
                      _emailController.text,
                      _passwordController.text,
                    );
                    if (user != null) {
                      widget.navigator.currentState
                          ?.pushReplacementNamed('/token');
                    } else {
                      showErrorToast('Registration failed. Please try again.');
                    }
                  } catch (e) {
                    if (kDebugMode) {
                      print("Error at the Register: $e");
                    }
                    showErrorToast(e.toString());
                  }
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
