import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PersonalMeasuresPage extends StatelessWidget {
  final List<TextEditingController> controllerList;

  const PersonalMeasuresPage({
    Key? key,
    required this.controllerList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Measurments',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controllerList[0],
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: 'Current Weight',
          ),
        ),
        TextField(
          controller: controllerList[1],
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: 'Target Weight (optional)',
            hintText: 'optional',
          ),
        ),
        TextField(
          controller: controllerList[2],
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: 'Height',
          ),
        ),
      ],
    );
  }
}
