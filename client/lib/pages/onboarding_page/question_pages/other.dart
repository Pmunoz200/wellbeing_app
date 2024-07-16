import 'package:flutter/material.dart';

class OthersPage extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;
  final String? initialValue;

  const OthersPage({
    Key? key,
    required this.controller,
    required this.onSubmitted,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.text = initialValue ?? '';
    return Column(
      children: [
        Text(
          'Others',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
          child: TextField(
            controller: controller,
            maxLines: null, // Allows multiline input
            maxLength: 128, // Maximum allowed characters
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: 'Anything else you want to add?',
              labelStyle: TextStyle(color: Colors.grey[800]),
              filled: true,
              fillColor:
                  Colors.lightBlueAccent.withOpacity(0.1), // Background color
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(30.0)), // Curved edges
                borderSide: BorderSide.none, // No border
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            ),
            onChanged: onSubmitted,
          ),
        ),
      ],
    );
  }
}
