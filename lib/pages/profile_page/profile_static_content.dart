import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// This class includes the top section of the profile:
// Picture, name and email.
// Divided it because it doesnt change and fills a bunch of space.
class ProfileTopContent extends StatelessWidget {
  const ProfileTopContent({
    super.key,
    required this.user,
  });

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black)),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : const AssetImage('assets/default_profile.png')
                      as ImageProvider,
            ),
          ),
        ),
        const SizedBox(),
        Text(
          user?.displayName ?? "No name available",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          user?.email ?? "No email available",
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
