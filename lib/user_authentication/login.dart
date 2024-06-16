import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gemini_folder/services/auth_service.dart';
import 'package:gemini_folder/user_authentication/dialogs.dart';
import 'package:gemini_folder/util/toast_util.dart';

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
  bool _isLoading = false;

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

  // Check if the onboarding is required and navigate accordingly
  Future<void> _navigateAfterLogin(User? user) async {
    if (user != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userSnapshot = await userDoc.get();
      final onboardingCompleted =
          userSnapshot.data()?['onboardingCompleted'] ?? false;
      if (onboardingCompleted) {
        widget.navigator.currentState?.pushReplacementNamed('/token');
      } else {
        widget.navigator.currentState?.pushReplacementNamed('/onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Stack(
        children: [
          Padding(
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
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        User? user =
                            await _authService.signInWithEmailAndPassword(
                          _emailController.text,
                          _passwordController.text,
                        );
                        if (user != null) {
                          await _navigateAfterLogin(user);
                        } else {
                          showErrorToast('Login failed. Please try again.');
                        }
                      } catch (e) {
                        showErrorToast(e.toString());
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    }
                  },
                  child: const Text('Login with Email'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      User? user = await _authService.signInWithGoogle();
                      if (user != null) {
                        await _navigateAfterLogin(user);
                      } else {
                        showErrorToast(
                            'Google sign-in failed. Please try again.');
                      }
                    } catch (e) {
                      showErrorToast(e.toString());
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
                  child: const Text('Login with Google'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_validateInputs()) {
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        User? user =
                            await _authService.registerWithEmailAndPassword(
                          _emailController.text,
                          _passwordController.text,
                        );
                        if (user != null) {
                          await _navigateAfterLogin(user);
                        } else {
                          showErrorToast(
                              'Registration failed. Please try again.');
                        }
                      } catch (e) {
                        showErrorToast(e.toString());
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    }
                  },
                  child: const Text('Register'),
                ),
                TextButton(
                  onPressed: () => showResetPasswordDialog(context, _authService),
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
