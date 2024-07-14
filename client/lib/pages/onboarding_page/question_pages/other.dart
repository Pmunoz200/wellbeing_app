import 'package:flutter/material.dart';

class OthersPage extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;

  const OthersPage({
    Key? key,
    required this.controller,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Others',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: controller,
            maxLines: null, // Allows multiline input
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: 'Anything else you want to add?',
              border: OutlineInputBorder(),
            ),
            onChanged: onSubmitted,
          ),
        ],
      ),
    );
  }
}
