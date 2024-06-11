import 'package:flutter/material.dart';

class TextResponseContainer extends StatelessWidget {
  final String text;

  const TextResponseContainer({required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          child: Card(
            color: Color(0xFFEDF1F8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(right: 16.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Text("Summary", style: TextStyle(color: Colors.grey[800], fontSize: 15.0, fontWeight: FontWeight.bold)))
            ,
          )
      ],
    );
  }
}