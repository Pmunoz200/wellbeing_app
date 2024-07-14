import 'package:flutter/material.dart';

class DietaryPreferencesPage extends StatefulWidget {
  final TextEditingController controller;
  final Function(String, {bool remove}) onPreferenceSelected;

  const DietaryPreferencesPage({
    Key? key,
    required this.controller,
    required this.onPreferenceSelected,
  }) : super(key: key);

  @override
  _DietaryPreferencesPageState createState() => _DietaryPreferencesPageState();
}

class _DietaryPreferencesPageState extends State<DietaryPreferencesPage> {
  List<String> preferences = ['Indifferent', 'Vegetarian', 'Vegan', 'Custom'];
  List<String> selectedPreferences = [];
  bool isCustomPreferenceSelected = false;

  void _handleCheckboxChange(String preference, bool isChecked) {
    setState(() {
      if (isChecked) {
        selectedPreferences.add(preference);
        widget.onPreferenceSelected(preference);
      } else {
        selectedPreferences.remove(preference);
        widget.onPreferenceSelected(preference, remove: true);
      }
    });

    if (preference == 'Custom') {
      setState(() {
        isCustomPreferenceSelected = isChecked;
        if (!isChecked) {
          widget.controller.clear();
        }
      });
    }
  }

  void _handleCustomPreferenceChange(String customPreference) {
    if (customPreference.isNotEmpty) {
      widget.onPreferenceSelected(customPreference);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dietary Preferences',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        ...preferences.map((preference) {
          return CheckboxListTile(
            title: Text(preference),
            value: selectedPreferences.contains(preference),
            onChanged: (isChecked) =>
                _handleCheckboxChange(preference, isChecked ?? false),
          );
        }).toList(),
        if (isCustomPreferenceSelected)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: 'Describe your custom dietary preferences',
              ),
              onChanged: _handleCustomPreferenceChange,
            ),
          ),
      ],
    );
  }
}
