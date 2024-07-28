import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PersonalMeasuresPage extends StatelessWidget {
  final List<TextEditingController> controllerList;
  final String? initialCurrentWeight;
  final String? initialTargetWeight;
  final String? initialHeight;

  const PersonalMeasuresPage({
    Key? key,
    required this.controllerList,
    this.initialCurrentWeight,
    this.initialTargetWeight,
    this.initialHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controllerList[0].text = initialCurrentWeight ?? '';
    controllerList[1].text = initialTargetWeight ?? '';
    controllerList[2].text = initialHeight ?? '';
    return Column(
      children: [
        Text(
          'Measurments',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
          child: TextField(
            controller: controllerList[0],
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Current Weight',
              labelStyle: TextStyle(color: Colors.grey[800]),
              suffixText: 'Kg',
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
            controller: controllerList[1],
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Target Weight (optional)',
              labelStyle: TextStyle(color: Colors.grey[800]),
              suffixText: 'Kg',
              hintText: 'optional',
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
            controller: controllerList[2],
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Height',
              labelStyle: TextStyle(color: Colors.grey[800]),
              suffixText: 'Cm',
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
      ],
    );
  }
}
