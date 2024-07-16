import 'package:flutter/material.dart';

class TrainingStylesPage extends StatefulWidget {
  final TextEditingController controller;
  final Function(String, {bool remove}) onStyleSelected;
  final List<String>? initialValue;

  const TrainingStylesPage({
    Key? key,
    required this.controller,
    required this.onStyleSelected,
    this.initialValue,
  }) : super(key: key);

  @override
  _TrainingStylesPageState createState() => _TrainingStylesPageState();
}

class _TrainingStylesPageState extends State<TrainingStylesPage> {
  List<String> styles = [
    'Calisthenics',
    'Weight Training',
    'Cardio',
    'Crossfit',
    'Sports',
    'Custom'
  ];
  List<String> selectedStyles = [];
  bool isCustomStyleSelected = false;

  void _handleCheckboxChange(String style, bool isChecked) {
    setState(() {
      if (isChecked) {
        selectedStyles.add(style);
        widget.onStyleSelected(style);
      } else {
        selectedStyles.remove(style);
        widget.onStyleSelected(style, remove: true);
      }
    });

    if (style == 'Custom') {
      setState(() {
        isCustomStyleSelected = isChecked;
        if (!isChecked) {
          widget.controller.clear();
        }
      });
    }
  }

  void _handleCustomStyleChange(String customStyle) {
    if (customStyle.isNotEmpty) {
      widget.onStyleSelected(customStyle);
    }
  }

  @override
  void initState() {
    super.initState();
    selectedStyles = widget.initialValue!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Training Styles',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        ...styles.map((style) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
            child: CheckboxListTile(
              title: Text(
                style,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: selectedStyles.contains(style),
              onChanged: (isChecked) =>
                  _handleCheckboxChange(style, isChecked ?? false),
              activeColor: Colors.blue,
              checkColor: Colors.white,
              // tileColor: Colors.lightBlueAccent.withOpacity(0.1),
            ),
          );
        }).toList(),
        if (isCustomStyleSelected)
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: 'Describe your custom training style',
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
              // onChanged: _handleCustomStyleChange,
            ),
          ),
      ],
    );
  }
}
