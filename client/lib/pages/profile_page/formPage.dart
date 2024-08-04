import 'package:flutter/material.dart';
import 'package:gemini_folder/pages/onboarding_page/onboarding_form.dart';

class FormPageWidget extends StatefulWidget {
  final FormStateData formState;
  final String title;

  const FormPageWidget({
    Key? key,
    required this.formState,
    required this.title,
  }) : super(key: key);

  @override
  _FormPageWidgetState createState() => _FormPageWidgetState();
}

class _FormPageWidgetState extends State<FormPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Form(
                  child: ListView(
                    shrinkWrap: true,
                    children: widget.formState.fields.map((field) {
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
                              widget.formState.dropdownValues[field.db_label] =
                                  newValue;
                            });
                          },
                          value:
                              widget.formState.dropdownValues[field.db_label],
                        );
                      } else if (field.checkboxItems != null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                field.label,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                            ...List.generate(field.checkboxItems!.length,
                                (index) {
                              return CheckboxListTile(
                                title: Text(field.checkboxItems![index]),
                                value: widget.formState
                                            .checkboxValues[field.db_label]
                                        ?[index] ??
                                    false,
                                onChanged: (newValue) {
                                  setState(() {
                                    widget.formState.checkboxValues[field
                                        .db_label]![index] = newValue ?? false;
                                  });
                                },
                              );
                            }),
                          ],
                        );
                      } else {
                        return TextFormField(
                          controller:
                              widget.formState.textControllers[field.db_label],
                          decoration: InputDecoration(labelText: field.label),
                          keyboardType: field.keyboardType,
                        );
                      }
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
