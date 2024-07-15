import 'package:flutter/material.dart';

class NutritionalGoalsPage extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onGoalSelected;
  final String? initialValue;

  const NutritionalGoalsPage({
    Key? key,
    required this.controller,
    required this.onGoalSelected,
    this.initialValue,
  }) : super(key: key);

  @override
  _NutritionalGoalsPageState createState() => _NutritionalGoalsPageState();
}

class _NutritionalGoalsPageState extends State<NutritionalGoalsPage> {
  String? _selectedGoal;
  bool isCustomGoalSelected = false;

  void _handleRadioValueChange(String? value) {
    setState(() {
      _selectedGoal = value;
      if (value == 'Custom') {
        isCustomGoalSelected = true;
      } else {
        isCustomGoalSelected = false;
        widget.controller
            .clear(); // Clear custom goal text field if another option is selected
      }
    });
    widget.onGoalSelected(value!);
  }

  void _handleCustomGoalChange(String customGoal) {
    if (customGoal.isNotEmpty) {
      widget.onGoalSelected(customGoal);
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedGoal = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nutritional Goals',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        RadioListTile<String>(
          title: Text('Let the App Decide'),
          value: 'Let the App Decide',
          groupValue: _selectedGoal,
          onChanged: _handleRadioValueChange,
        ),
        RadioListTile<String>(
          title: Text('Custom'),
          value: 'Custom',
          groupValue: _selectedGoal,
          onChanged: _handleRadioValueChange,
        ),
        if (isCustomGoalSelected)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: 'Describe your custom nutritional goal',
              ),
              onChanged: _handleCustomGoalChange,
            ),
          ),
      ],
    );
  }
}
