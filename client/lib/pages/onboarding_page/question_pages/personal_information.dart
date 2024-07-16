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
      children: [
        Text(
          'Personal Information',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
          child: TextField(
            controller: widget.controllerList[0],
            decoration: InputDecoration(
              labelText: 'Name',
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
          child: TextField(
            controller: widget.controllerList[1],
            decoration: InputDecoration(
              labelText: 'Lastname',
              labelStyle: TextStyle(color: Colors.grey[800]), filled: true,
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
          child: TextField(
            controller: widget.controllerList[2],
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Age', 
              labelStyle: TextStyle(color: Colors.grey[800]),filled: true,
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
          child: DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: InputDecoration(
              labelText: 'Gender', 
              labelStyle: TextStyle(color: Colors.grey[800]),filled: true,
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
            items: ['Male', 'Female', 'Other']
                .map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    ))
                .toList(),
            onChanged: _handleGenderChange,
          ),
        ),
        if (_isOtherSelected)
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
            child: TextField(
              controller: widget.controllerList[3],
              decoration: InputDecoration(
                labelText: 'Please specify gender', 
                labelStyle: TextStyle(color: Colors.grey[800]),filled: true,
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
              onChanged: _handleCustomGenderChange,
            ),
          ),
      ],
    );
  }
}
