import 'package:flutter/material.dart';

class ActivityLevelPage extends StatefulWidget {
  final ValueChanged<String> onSelected;

  const ActivityLevelPage({
    Key? key,
    required this.onSelected,
  }) : super(key: key);

  @override
  _ActivityLevelPageState createState() => _ActivityLevelPageState();
}

class _ActivityLevelPageState extends State<ActivityLevelPage> {
  String? _selectedActivityLevel;

  void _handleRadioValueChange(String? value) {
    setState(() {
      _selectedActivityLevel = value;
    });
    widget.onSelected(value!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Activity Level',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        RadioListTile<String>(
          title: Text('Sedentary: Little or no exercise'),
          value: 'Sedentary: Little or no exercise',
          groupValue: _selectedActivityLevel,
          onChanged: _handleRadioValueChange,
        ),
        RadioListTile<String>(
          title: Text('Lightly Active: Light exercise or sports 1-3 days a week'),
          value: 'Lightly Active: Light exercise or sports 1-3 days a week',
          groupValue: _selectedActivityLevel,
          onChanged: _handleRadioValueChange,
        ),
        RadioListTile<String>(
          title: Text('Moderately Active: Moderate exercise or sports 3-5 days a week'),
          value: 'Moderately Active: Moderate exercise or sports 3-5 days a week',
          groupValue: _selectedActivityLevel,
          onChanged: _handleRadioValueChange,
        ),
        RadioListTile<String>(
          title: Text('Very Active: Hard exercise or sports 6-7 days a week'),
          value: 'Very Active: Hard exercise or sports 6-7 days a week',
          groupValue: _selectedActivityLevel,
          onChanged: _handleRadioValueChange,
        ),
        RadioListTile<String>(
          title: Text('Super Active: Very hard exercise, physical job, or training twice a day'),
          value: 'Super Active: Very hard exercise, physical job, or training twice a day',
          groupValue: _selectedActivityLevel,
          onChanged: _handleRadioValueChange,
        ),
      ],
    );
  }
}
