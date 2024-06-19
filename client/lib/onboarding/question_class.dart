import 'package:flutter/material.dart';

class OnboardingQuestion {
  final String question;
  final TextInputType inputType;
  final List<String>? options;
  final bool isOptional;
  final bool allowMultipleSelections; // New flag for multiple selections

  OnboardingQuestion({
    required this.question,
    this.inputType = TextInputType.text,
    this.options,
    this.isOptional = false,
    this.allowMultipleSelections = false, // Default to false
  });
}
