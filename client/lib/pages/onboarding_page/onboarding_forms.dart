import 'package:flutter/material.dart';

// Define the FormFieldData class
class FormFieldData {
  final String label;
  final TextInputType keyboardType;
  final List<String>? dropdownItems;
  final List<String>? checkboxItems;

  FormFieldData({
    required this.label,
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
        dropdownValues[field.label] = null;
      } else if (field.checkboxItems != null) {
        checkboxValues[field.label] =
            List<bool>.filled(field.checkboxItems!.length, false);
      } else {
        textControllers[field.label] = TextEditingController();
      }
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    textControllers.forEach((key, value) {
      data[key] = value.text;
    });
    dropdownValues.forEach((key, value) {
      data[key] = value;
    });
    checkboxValues.forEach((key, value) {
      final selectedItems = fields
          .firstWhere((field) => field.label == key)
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
                    formState.dropdownValues[field.label] = newValue;
                  });
                },
                value: formState.dropdownValues[field.label],
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
                      value: formState.checkboxValues[field.label]![index],
                      onChanged: (newValue) {
                        setState(() {
                          formState.checkboxValues[field.label]![index] =
                              newValue ?? false;
                        });
                      },
                    );
                  }),
                ],
              );
            } else {
              return TextFormField(
                controller: formState.textControllers[field.label],
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
      FormFieldData(label: 'Name'),
      FormFieldData(label: 'Age', keyboardType: TextInputType.number),
      FormFieldData(
        label: 'Gender',
        dropdownItems: ['Male', 'Female', 'Other'],
      ),
    ],
    'contactInformation': [
      FormFieldData(label: 'Address'),
      FormFieldData(label: 'Phone Number', keyboardType: TextInputType.phone),
      FormFieldData(
        label: 'Receive Newsletter',
        checkboxItems: ['Yes'],
      ),
    ],
    'preferences': [
      FormFieldData(label: 'Favorite Hobby'),
      FormFieldData(label: 'Favorite Color'),
      FormFieldData(
        label: 'Favorite Food',
        dropdownItems: ['Pizza', 'Burger', 'Pasta', 'Salad'],
      ),
    ],
  };
}
