import 'package:flutter/material.dart';

class GoalPage extends StatefulWidget {
  final TextEditingController controller;
  final Function(String, {bool remove}) onGoalSelected;
  final List<String>? initialValue;

  const GoalPage({
    Key? key,
    required this.controller,
    required this.onGoalSelected,
    this.initialValue,
  }) : super(key: key);

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  List<String> goals = [
    'General Health',
    'Lose Weight',
    'Gain Muscle',
    'Body Recomposition (Gain muscle + Lose fat)',
    'Gain Strength',
    'Improve Endurance/Resistance',
    'Custom Goal'
  ];
  List<String> selectedGoals = [];
  bool isCustomGoalSelected = false;

  void _handleCheckboxChange(String goal, bool isChecked) {
    setState(() {
      if (isChecked) {
        selectedGoals.add(goal);
        widget.onGoalSelected(goal);
      } else {
        selectedGoals.remove(goal);
        widget.onGoalSelected(goal, remove: true);
      }
    });

    if (goal == 'Custom Goal') {
      setState(() {
        isCustomGoalSelected = isChecked;
        if (!isChecked) {
          widget.controller.clear();
        }
      });
    }
  }

  void _handleCustomGoalChange(String customGoal) {
    if (customGoal.isNotEmpty) {
      widget.onGoalSelected(customGoal);
    }
  }

  @override
  void initState() {
    super.initState();
    selectedGoals = widget.initialValue!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Goal',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        ...goals.map((goal) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
            child: CheckboxListTile(
              title: Text(
                goal,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: selectedGoals.contains(goal),
              onChanged: (isChecked) =>
                  _handleCheckboxChange(goal, isChecked ?? false),
              activeColor: Colors.blue,
              checkColor: Colors.white,
              // tileColor: Colors.lightBlueAccent.withOpacity(0.1),
            ),
          );
        }).toList(),
        if (isCustomGoalSelected)
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: 'Describe your custom goal',
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
              // onChanged: _handleCustomGoalChange,
            ),
          ),
      ],
    );
  }
}
