import 'package:flutter/material.dart';
import 'package:gemini_folder/services/auth_service.dart';
import 'package:gemini_folder/util/toast_util.dart';

Future<void> showResetPasswordDialog(
    BuildContext context, AuthService authService) {
  final TextEditingController resetEmailController = TextEditingController();
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Reset Password'),
        content: TextField(
          controller: resetEmailController,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Send'),
            onPressed: () {
              try {
                authService.sendPasswordResetEmail(resetEmailController.text);
                showSuccessToast('Password reset email sent.');
              } catch (e) {
                showErrorToast(
                    'Failed to send password reset email. Please try again.');
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
