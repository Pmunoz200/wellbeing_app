import 'package:flutter/material.dart';

class TokenPage extends StatelessWidget {
  const TokenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Token'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'You have successfully logged in and received a token!',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
