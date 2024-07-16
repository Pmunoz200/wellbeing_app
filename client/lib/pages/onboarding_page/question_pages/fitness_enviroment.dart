import 'package:flutter/material.dart';

class FitnessEnvironmentPage extends StatefulWidget {
  final TextEditingController controller;
  final Function(String, {bool remove}) onEnvironmentSelected;
  final List<String>? initialValue;

  const FitnessEnvironmentPage({
    Key? key,
    required this.controller,
    required this.onEnvironmentSelected,
    this.initialValue,
  }) : super(key: key);

  @override
  _FitnessEnvironmentPageState createState() => _FitnessEnvironmentPageState();
}

class _FitnessEnvironmentPageState extends State<FitnessEnvironmentPage> {
  List<String> environments = [
    'Gym Workouts',
    'Home Workouts',
    'Outdoors',
    'Custom',
  ];
  List<String> selectedEnvironments = [];
  bool isCustomEnvironmentSelected = false;

  void _handleCheckboxChange(String environment, bool isChecked) {
    setState(() {
      if (isChecked) {
        selectedEnvironments.add(environment);
        widget.onEnvironmentSelected(environment);
      } else {
        selectedEnvironments.remove(environment);
        widget.onEnvironmentSelected(environment, remove: true);
      }
    });

    if (environment == 'Custom') {
      setState(() {
        isCustomEnvironmentSelected = isChecked;
        if (!isChecked) {
          widget.controller.clear();
        }
      });
    }
  }

  void _handleCustomEnvironmentChange(String customEnvironment) {
    if (customEnvironment.isNotEmpty) {
      widget.onEnvironmentSelected(customEnvironment);
    }
  }

  @override
  void initState() {
    super.initState();
    selectedEnvironments = widget.initialValue!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Fitness Environment',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
...environments.map((environment) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
    child: CheckboxListTile(
      title: Text(
        environment,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      value: selectedEnvironments.contains(environment),
      onChanged: (isChecked) =>
          _handleCheckboxChange(environment, isChecked ?? false),
      activeColor: Colors.blue,
      checkColor: Colors.white,
      // tileColor: Colors.lightBlueAccent.withOpacity(0.1),
    ),
  );
}).toList(),
if (isCustomEnvironmentSelected)
  Padding(
    padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
    child: TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: 'Custom fitness environment',
        labelStyle: TextStyle(color: Colors.grey[800]),
        filled: true,
        fillColor: Colors.lightBlueAccent.withOpacity(0.1), // Background color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)), // Curved edges
          borderSide: BorderSide.none, // No border
        ),
        contentPadding:
            EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      ),
      // onChanged: _handleCustomEnvironmentChange,
    ),
  ),

      ],
    );
  }
}
