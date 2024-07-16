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
      children: [
        Text(
          'Dietary Preferences',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
// Dietary Preferences RadioListTiles
        RadioListTile<String>(
          title: Text(
            'Indifferent',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          value: 'Indifferent',
          groupValue: _selectedPreference,
          onChanged: _handleRadioValueChange,
          activeColor: Colors.blue,
          visualDensity: VisualDensity.compact,
        ),
        RadioListTile<String>(
          title: Text(
            'Vegetarian',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          value: 'Vegetarian',
          groupValue: _selectedPreference,
          onChanged: _handleRadioValueChange,
          activeColor: Colors.blue,
          visualDensity: VisualDensity.compact,
        ),
        RadioListTile<String>(
          title: Text(
            'Vegan',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          value: 'Vegan',
          groupValue: _selectedPreference,
          onChanged: _handleRadioValueChange,
          activeColor: Colors.blue,
          visualDensity: VisualDensity.compact,
        ),
        RadioListTile<String>(
          title: Text(
            'Custom',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          value: 'Custom',
          groupValue: _selectedPreference,
          onChanged: (value) {
            _handleRadioValueChange(value);
            setState(() {
              isCustomPreferenceSelected = value == 'Custom';
            });
          },
          activeColor: Colors.blue,
          visualDensity: VisualDensity.compact,
        ),
        if (isCustomPreferenceSelected)
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: 'Custom dietary preferences',
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
              onChanged: _handleCustomPreferenceChange,
            ),
          ),
      ],
    );
  }
}
