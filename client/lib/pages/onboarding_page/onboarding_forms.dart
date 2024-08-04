import 'package:flutter/material.dart';

// Define the FormFieldData class
class FormFieldData {
  final String label;
  final String db_label;
  final TextInputType keyboardType;
  final List<String>? dropdownItems;
  final List<String>? checkboxItems;

  FormFieldData({
    required this.label,
    required this.db_label,
    this.keyboardType = TextInputType.text,
    this.dropdownItems,
    this.checkboxItems,
  });
}

// Define the FormStateData class
class FormStateData {
  final List<FormFieldData> fields;
  final Map<String, TextEditingController> textControllers = {};
  final Map<String, String?> dropdownValues = {};
  final Map<String, List<bool>> checkboxValues = {};

  FormStateData(this.fields) {
    for (var field in fields) {
      if (field.dropdownItems != null) {
        dropdownValues[field.db_label] = null;
      } else if (field.checkboxItems != null) {
        checkboxValues[field.db_label] =
            List<bool>.filled(field.checkboxItems!.length, false);
      } else {
        textControllers[field.db_label] = TextEditingController();
      }
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    textControllers.forEach((key, value) {
      var field = fields.firstWhere((field) => field.db_label == key);
      if (field.keyboardType == TextInputType.number) {
        // Attempt to parse as int, fall back to double if necessary
        if (value.text.contains('.')) {
          data[key] = double.tryParse(value.text);
        } else {
          data[key] = int.tryParse(value.text);
        }
      } else {
        data[key] = value.text;
      }
    });
    dropdownValues.forEach((key, value) {
      data[key] = value;
    });
    checkboxValues.forEach((key, value) {
      final selectedItems = fields
          .firstWhere((field) => field.db_label == key)
          .checkboxItems!
          .asMap()
          .entries
          .where((entry) => value[entry.key])
          .map((entry) => entry.value)
          .toList();
      data[key] = selectedItems;
    });
    return data;
  }
}

// Function to build a form page
Widget buildFormPage(
    FormStateData formState, Function(void Function()) setState) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        child: ListView(
          children: formState.fields.map((field) {
            if (field.dropdownItems != null) {
              return DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: field.label),
                items: field.dropdownItems!.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    formState.dropdownValues[field.db_label] = newValue;
                  });
                },
                value: formState.dropdownValues[field.db_label],
              );
            } else if (field.checkboxItems != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      field.label,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  ...List.generate(field.checkboxItems!.length, (index) {
                    return CheckboxListTile(
                      title: Text(field.checkboxItems![index]),
                      value: formState.checkboxValues[field.db_label]![index],
                      onChanged: (newValue) {
                        setState(() {
                          formState.checkboxValues[field.db_label]![index] =
                              newValue ?? false;
                        });
                      },
                    );
                  }),
                ],
              );
            } else {
              return TextFormField(
                controller: formState.textControllers[field.db_label],
                decoration: InputDecoration(labelText: field.label),
                keyboardType: field.keyboardType,
              );
            }
          }).toList(),
        ),
      ),
    ),
  );
}

// Function to get form configurations
Map<String, List<FormFieldData>> getFormConfigs() {
  return {
    'personalInformation': [
      FormFieldData(label: 'Name', db_label: 'name'),
      FormFieldData(
          label: 'Age', db_label: 'age', keyboardType: TextInputType.number),
      FormFieldData(
        label: 'Gender',
        db_label: 'gender',
        dropdownItems: ['Male', 'Female', 'Other'],
      ),
    ],
    'physicalMeasurements': [
      FormFieldData(
          label: 'Current Weight',
          db_label: 'currentWeight',
          keyboardType: TextInputType.number),
      FormFieldData(
          label: 'Target Weight',
          db_label: 'targetWeight',
          keyboardType: TextInputType.number),
      FormFieldData(
          label: 'Height',
          db_label: 'height',
          keyboardType: TextInputType.number),
    ],
    'activityLevel': [
      FormFieldData(
        label: 'Activity Level',
        db_label: 'activityLevel',
        dropdownItems: ['Sedentary', 'Lightly Active', 'Moderately Active'],
      ),
      FormFieldData(
        label: 'Custom Activity Level',
        db_label: 'customActivityLevel',
        keyboardType: TextInputType.text,
      ),
    ],
  };
}
