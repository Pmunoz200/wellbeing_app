import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PersonalInformationPage extends StatefulWidget {
  final List<TextEditingController> controllerList;
  final ValueChanged<String> onGenderChanged;
  final String? initialName;
  final String? initialLastname;
  final String? initialAge;
  final String? initialGender;

  const PersonalInformationPage({
    Key? key,
    required this.controllerList,
    required this.onGenderChanged,
    this.initialName,
    this.initialLastname,
    this.initialAge,
    this.initialGender,
  }) : super(key: key);

  @override
  _PersonalInformationPageState createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  String _selectedGender = 'Male';
  bool _isOtherSelected = false;

  void _handleGenderChange(String? value) {
    setState(() {
      _selectedGender = value!;
      _isOtherSelected = _selectedGender == 'Other';
    });
    widget.onGenderChanged(_selectedGender);
  }

  void _handleCustomGenderChange(String customGender) {
    widget.onGenderChanged(customGender);
  }

  @override
  void initState() {
    super.initState();
    widget.controllerList[0].text = widget.initialName ?? '';
    widget.controllerList[1].text = widget.initialLastname ?? '';
    widget.controllerList[2].text = widget.initialAge ?? '';
    _selectedGender = widget.initialGender ?? 'Male';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: widget.controllerList[0],
          decoration: InputDecoration(labelText: 'Name'),
        ),
        TextField(
          controller: widget.controllerList[1],
          decoration: InputDecoration(labelText: 'Lastname'),
        ),
        TextField(
          controller: widget.controllerList[2],
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(labelText: 'Age'),
        ),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          decoration: InputDecoration(labelText: 'Gender'),
          items: ['Male', 'Female', 'Other']
              .map((gender) => DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  ))
              .toList(),
          onChanged: _handleGenderChange,
        ),
        if (_isOtherSelected)
          TextField(
            controller: widget.controllerList[3],
            decoration: InputDecoration(labelText: 'Please specify gender'),
            onChanged: _handleCustomGenderChange,
          ),
      ],
    );
  }
}
