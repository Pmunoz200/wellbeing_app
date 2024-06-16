import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gemini_folder/services/auth_service.dart';
import 'package:gemini_folder/util/toast_util.dart';

class TokenPage extends StatelessWidget {
  final GlobalKey<NavigatorState> navigator;
  const TokenPage( {super.key, required this.navigator});

  Future<void> _logout(BuildContext context) async {
    try {
      final AuthService authService = AuthService();
      await authService.signOut();
      navigator.currentState?.pushReplacementNamed('/authentication');
    } catch (e) {
      if (kDebugMode) {
        print("ERROR DURING LOGOUT: $e");
      }
      showErrorToast("Logout failed. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Token Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'User ID: ${user?.uid ?? "No user logged in"}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${user?.email ?? "No email available"}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
