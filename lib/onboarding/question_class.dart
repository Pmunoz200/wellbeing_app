import 'package:flutter/material.dart';

class OnboardingQuestion {
  final String question;
  final TextInputType inputType;
  final bool isOptional;
  final List<String>? options;

  OnboardingQuestion({
    required this.question,
    this.inputType = TextInputType.text,
    this.isOptional = false,
    this.options,
  });
}

