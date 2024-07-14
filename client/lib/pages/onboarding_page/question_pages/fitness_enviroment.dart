import 'package:flutter/material.dart';

class FitnessEnvironmentPage extends StatefulWidget {
  final TextEditingController controller;
  final Function(String, {bool remove}) onEnvironmentSelected;

  const FitnessEnvironmentPage({
    Key? key,
    required this.controller,
    required this.onEnvironmentSelected,
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fitness Environment',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          ...environments.map((environment) {
            return CheckboxListTile(
              title: Text(environment),
              value: selectedEnvironments.contains(environment),
              onChanged: (isChecked) =>
                  _handleCheckboxChange(environment, isChecked ?? false),
            );
          }).toList(),
          if (isCustomEnvironmentSelected)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: widget.controller,
                decoration: InputDecoration(
                  labelText: 'Describe your custom fitness environment',
                ),
                onChanged: _handleCustomEnvironmentChange,
              ),
            ),
        ],
      ),
    );
  }
}
