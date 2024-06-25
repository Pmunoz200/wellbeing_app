import 'package:flutter/material.dart';

class OnboardingQuestion {
  final String question;
  final TextInputType? inputType;
  final List<String>? options;
  final bool isOptional;
  final bool allowMultipleSelections;
  final String parameterName; // Name to use in the db
  final bool addCustomField; // Allows users to add a custom entry value

  OnboardingQuestion({
    required this.question,
    this.inputType,
    this.options,
    this.isOptional = false,
    required this.allowMultipleSelections,
    required this.parameterName,
    required this.addCustomField,
  });
}
