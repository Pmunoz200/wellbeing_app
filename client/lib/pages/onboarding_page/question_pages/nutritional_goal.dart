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
      children: [
        Text(
          'Nutritional Goals',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
// RadioListTiles for Goals
        RadioListTile<String>(
          title: Text(
            'Let the App Decide',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          value: 'Let the App Decide',
          groupValue: _selectedGoal,
          onChanged: (value) {
            _handleRadioValueChange(value);
            setState(() {
              isCustomGoalSelected = value == 'Custom';
            });
          },
          activeColor: Colors.blue,
          visualDensity: VisualDensity.compact,
        ),
        RadioListTile<String>(
          title: Text(
            'Custom',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          value: 'Custom',
          groupValue: _selectedGoal,
          onChanged: (value) {
            _handleRadioValueChange(value);
            setState(() {
              isCustomGoalSelected = value == 'Custom';
            });
          },
          activeColor: Colors.blue,
          visualDensity: VisualDensity.compact,
        ),
        if (isCustomGoalSelected)
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: 'Custom nutritional goal',
                labelStyle: TextStyle(color: Colors.grey[800]),
                filled: true,
                fillColor: Colors.lightBlueAccent.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              ),
              onChanged: _handleCustomGoalChange,
            ),
          ),
      ],
    );
  }
}
