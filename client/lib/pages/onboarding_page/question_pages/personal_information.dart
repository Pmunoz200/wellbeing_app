import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PersonalInformationPage extends StatefulWidget {
  final List<TextEditingController> controllerList;

  const PersonalInformationPage({Key? key, required this.controllerList})
      : super(key: key);

  @override
  _PersonalInformationPageState createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  String _selectedGender = 'Male';
  bool _isOtherSelected = false;

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
          onChanged: (value) {
            setState(() {
              _selectedGender = value!;
              _isOtherSelected = _selectedGender == 'Other';
            });
          },
        ),
        if (_isOtherSelected)
          TextField(
            controller: widget.controllerList[3],
            decoration: InputDecoration(labelText: 'Please specify gender'),
          ),
      ],
    );
  }
}
