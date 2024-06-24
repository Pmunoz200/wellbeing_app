import 'package:flutter/material.dart';
import 'package:gemini_folder/onboarding/question_class.dart';

final List<OnboardingQuestion> questions = [
  OnboardingQuestion(
    question: 'Age',
    parameterName: 'age',
    inputType: TextInputType.number,
    isOptional: false,
    allowMultipleSelections: false,
    addCustomField: false,
  ),
  OnboardingQuestion(
    question: 'Gender',
    parameterName: 'gender',
    isOptional: false,
    allowMultipleSelections: false,
    options: ["Male", "Female"],
    addCustomField: true,
  ),
  // Physical Measurements
  OnboardingQuestion(
      question: 'Current Weight (Kg)',
      parameterName: 'currentWeight',
      inputType: TextInputType.number,
      isOptional: false,
      allowMultipleSelections: false,
      addCustomField: false),
  OnboardingQuestion(
      question: 'Target Weight (Kg)',
      parameterName: 'targetWeight',
      inputType: TextInputType.number,
      isOptional: true,
      allowMultipleSelections: false,
      addCustomField: false),
  OnboardingQuestion(
      question: 'Height (cm)',
      parameterName: 'height',
      inputType: TextInputType.number,
      isOptional: false,
      allowMultipleSelections: false,
      addCustomField: false),

  // Activity Level
  OnboardingQuestion(
      question: 'Activity Level',
      parameterName: 'activityLevel',
      options: [
        'Sedentary: Little or no exercise',
        'Lightly Active: Light exercise or sports 1-3 days a week',
        'Moderately Active: Moderate exercise or sports 3-5 days a week',
        'Very Active: Hard exercise or sports 6-7 days a week',
        'Super Active: Very hard exercise, physical job, or training twice a day',
      ],
      isOptional: false,
      allowMultipleSelections: false,
      addCustomField: false),
  OnboardingQuestion(
    question: 'Goal',
    parameterName: 'goal',
    options: [
      'General Health',
      'Lose Weight',
      'Gain Muscle',
      'Body Recomposition (Gain muscle + Lose fat)',
      'Gain Strength',
      'Improve Endurance/Resistance',
    ],
    isOptional: false,
    allowMultipleSelections: true,
    addCustomField: true,
  ),
  // Dietary Preferences
  OnboardingQuestion(
    question: 'Dietary Preferences',
    parameterName: 'dietaryPreferences',
    options: ['Indifferent', 'Vegetarian', 'Vegan'],
    isOptional: false,
    allowMultipleSelections: false,
    addCustomField: true,
  ),

  // Nutritional Goals
  OnboardingQuestion(
    question: 'Nutritional Goals',
    parameterName: 'nutritionalGoals',
    options: [
      'Let the App Decide',
      'Increase caloric intake',
      'Decrease caloric intake',
      'No preference',
    ],
    isOptional: false,
    allowMultipleSelections: false,
    addCustomField: true,
  ),
  // Fitness Environment
  OnboardingQuestion(
    question: 'Fitness Environment',
    parameterName: 'fitnessEnvironment',
    options: ['Gym Workouts', 'Home Workouts', 'Outdoors'],
    allowMultipleSelections: true,
    isOptional: false,
    addCustomField: true,
  ),
  // Training Style
  OnboardingQuestion(
    question: 'Training Style',
    parameterName: 'trainingStyle',
    options: [
      'Calisthenics',
      'Weight Training',
      'Cardio',
      'Crossfit',
      "Athlete",
    ],
    allowMultipleSelections: true,
    isOptional: false,
    addCustomField: true,
  ),

  // Other
  OnboardingQuestion(
    question: 'Other (Sports, Medical conditions, etc)',
    parameterName: 'other',
    inputType: TextInputType.text,
    isOptional: true,
    allowMultipleSelections: false,
    addCustomField: false,
  ),
];
