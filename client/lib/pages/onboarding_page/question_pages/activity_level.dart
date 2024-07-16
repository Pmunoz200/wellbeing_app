import 'package:flutter/material.dart';

class ActivityLevelPage extends StatefulWidget {
  final ValueChanged<String> onSelected;
  final String? initialValue;

  const ActivityLevelPage({
    Key? key,
    required this.onSelected,
    this.initialValue,
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
  void initState() {
    super.initState();
    _selectedActivityLevel = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Activity Level',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        RadioListTile<String>(
          title: RichText(
            text: TextSpan(
              text: 'Sedentary: ',
              style: TextStyle(
                  color: Colors.black, fontSize: 20), // Increased font size
              children: [
                TextSpan(
                  text: 'Little or no exercise',
                  style: TextStyle(
                      color: Colors.grey, fontSize: 20), // Increased font size
                ),
              ],
            ),
          ),
          value: 'Sedentary: Little or no exercise',
          groupValue: _selectedActivityLevel,
          onChanged: _handleRadioValueChange,
          activeColor: Colors.blue,
          visualDensity: VisualDensity.compact,
        ),
        RadioListTile<String>(
          title: RichText(
            text: TextSpan(
              text: 'Lightly Active: ',
              style: TextStyle(
                  color: Colors.black, fontSize: 20), // Increased font size
              children: [
                TextSpan(
                  text: 'Light exercise or sports 1-3 days a week',
                  style: TextStyle(
                      color: Colors.grey, fontSize: 20), // Increased font size
                ),
              ],
            ),
          ),
          value: 'Lightly Active: Light exercise or sports 1-3 days a week',
          groupValue: _selectedActivityLevel,
          onChanged: _handleRadioValueChange,
          activeColor: Colors.blue,
          visualDensity: VisualDensity.compact,
        ),
        RadioListTile<String>(
          title: RichText(
            text: TextSpan(
              text: 'Moderately Active: ',
              style: TextStyle(
                  color: Colors.black, fontSize: 20), // Increased font size
              children: [
                TextSpan(
                  text: 'Moderate exercise or sports 3-5 days a week',
                  style: TextStyle(
                      color: Colors.grey, fontSize: 20), // Increased font size
                ),
              ],
            ),
          ),
          value:
              'Moderately Active: Moderate exercise or sports 3-5 days a week',
          groupValue: _selectedActivityLevel,
          onChanged: _handleRadioValueChange,
          activeColor: Colors.blue,
          visualDensity: VisualDensity.compact,
        ),
        RadioListTile<String>(
          title: RichText(
            text: TextSpan(
              text: 'Very Active: ',
              style: TextStyle(
                  color: Colors.black, fontSize: 20), // Increased font size
              children: [
                TextSpan(
                  text: 'Hard exercise or sports 6-7 days a week',
                  style: TextStyle(
                      color: Colors.grey, fontSize: 20), // Increased font size
                ),
              ],
            ),
          ),
          value: 'Very Active: Hard exercise or sports 6-7 days a week',
          groupValue: _selectedActivityLevel,
          onChanged: _handleRadioValueChange,
          activeColor: Colors.blue,
          visualDensity: VisualDensity.compact,
        ),
        RadioListTile<String>(
          title: RichText(
            text: TextSpan(
              text: 'Super Active: ',
              style: TextStyle(
                  color: Colors.black, fontSize: 20), // Increased font size
              children: [
                TextSpan(
                  text:
                      'Very hard exercise, physical job, or training twice a day',
                  style: TextStyle(
                      color: Colors.grey, fontSize: 20), // Increased font size
                ),
              ],
            ),
          ),
          value:
              'Super Active: Very hard exercise, physical job, or training twice a day',
          groupValue: _selectedActivityLevel,
          onChanged: _handleRadioValueChange,
          activeColor: Colors.blue,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
