import 'package:flutter/material.dart';

class TextResponseContainer extends StatefulWidget {
  final List<String> texts;
  final String title;

  const TextResponseContainer({required this.texts, required this.title});

  @override
  _TextResponseContainerState createState() => _TextResponseContainerState();
}

class _TextResponseContainerState extends State<TextResponseContainer> {
  int _currentIndex = 0;

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
                widget.texts[_currentIndex],
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
            child: Text(
              widget.title,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  if (_currentIndex > 0) {
                    _currentIndex--;
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                setState(() {
                  if (_currentIndex < widget.texts.length - 1) {
                    _currentIndex++;
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}