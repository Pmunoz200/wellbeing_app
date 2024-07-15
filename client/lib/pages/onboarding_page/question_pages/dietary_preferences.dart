import 'package:flutter/material.dart';

class DietaryPreferencesPage extends StatefulWidget {
  final ValueChanged<String> onSelected;
  final TextEditingController controller;
  final String? initialValue;

  const DietaryPreferencesPage({
    Key? key,
    required this.controller,
    required this.onSelected,
    this.initialValue,
  }) : super(key: key);

  @override
  _DietaryPreferencesPageState createState() => _DietaryPreferencesPageState();
}

class _DietaryPreferencesPageState extends State<DietaryPreferencesPage> {
  String? _selectedPreference;
  bool isCustomPreferenceSelected = false;

  void _handleRadioValueChange(String? value) {
    setState(() {
      _selectedPreference = value;
      isCustomPreferenceSelected = value == 'Custom';
    });
    widget.onSelected(value!);
  }

  void _handleCustomPreferenceChange(String customPreference) {
    if (customPreference.isNotEmpty) {
      widget.onSelected(customPreference);
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedPreference = widget.initialValue;
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
        RadioListTile<String>(
          title: Text('Indifferent'),
          value: 'Indifferent',
          groupValue: _selectedPreference,
          onChanged: _handleRadioValueChange,
        ),
        RadioListTile<String>(
          title: Text('Vegetarian'),
          value: 'Vegetarian',
          groupValue: _selectedPreference,
          onChanged: _handleRadioValueChange,
        ),
        RadioListTile<String>(
          title: Text('Vegan'),
          value: 'Vegan',
          groupValue: _selectedPreference,
          onChanged: _handleRadioValueChange,
        ),
        RadioListTile<String>(
          title: Text('Custom'),
          value: 'Custom',
          groupValue: _selectedPreference,
          onChanged: _handleRadioValueChange,
        ),
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
