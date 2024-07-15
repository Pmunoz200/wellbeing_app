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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Training Styles',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        ...styles.map((style) {
          return CheckboxListTile(
            title: Text(style),
            value: selectedStyles.contains(style),
            onChanged: (isChecked) =>
                _handleCheckboxChange(style, isChecked ?? false),
          );
        }).toList(),
        if (isCustomStyleSelected)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: 'Describe your custom training style',
              ),
              // onChanged: _handleCustomStyleChange,
            ),
          ),
      ],
    );
  }
}
