// Function to get form configurations
import 'package:flutter/material.dart';
import 'package:gemini_folder/pages/onboarding_page/onboarding_form.dart';

Map<String, FormSectionData> getFormConfigs() {
  return {
    'personalInformation': FormSectionData(
      title: 'Personal Information',
      fields: [
        FormFieldData(label: 'Name', db_label: 'name'),
        FormFieldData(
            label: 'Age', db_label: 'age', keyboardType: TextInputType.number),
        FormFieldData(
          label: 'Gender',
          db_label: 'gender',
          dropdownItems: ['Male', 'Female', 'Other'],
        ),
      ],
    ),
    'physicalMeasurements': FormSectionData(
      title: 'Physical Measurements',
      fields: [
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
    ),
    'activityLevel': FormSectionData(
      title: 'Activity Level',
      fields: [
        FormFieldData(
          label: 'Activity Level',
          db_label: 'activityLevel',
          dropdownItems: [
            'Sedentary',
            'Lightly Active',
            'Moderately Active',
            'Very Active',
            'Extra Active'
          ],
        ),
        FormFieldData(
          label: 'Custom Activity Level (optional)',
          db_label: 'customActivityLevel',
          keyboardType: TextInputType.text,
        ),
      ],
    ),
    'goal': FormSectionData(
      title: 'Goal',
      fields: [
        FormFieldData(
          label: 'Goal',
          db_label: 'goal',
          checkboxItems: [
            'General Health',
            'Weight Loss',
            'Muscle Gain',
            'Endurance',
            'Strength'
          ],
        ),
        FormFieldData(
          label: 'Custom Goal (optional)',
          db_label: 'customGoal',
          keyboardType: TextInputType.text,
        ),
      ],
    ),
    'dietaryPreferences': FormSectionData(
      title: 'Dietary Preferences',
      fields: [
        FormFieldData(
          label: 'Dietary Preferences',
          db_label: 'dietaryPreferences',
          checkboxItems: [
            'Balanced',
            'Vegetarian',
            'Vegan',
          ],
        ),
        FormFieldData(
          label: 'Custom Dietary Preferences (optional)',
          db_label: 'customDietaryPreferences',
          keyboardType: TextInputType.text,
        ),
      ],
    ),
    'fitnessEnvironment': FormSectionData(
      title: 'Fitness Environment',
      fields: [
        FormFieldData(
          label: 'Fitness Environment',
          db_label: 'fitnessEnvironment',
          checkboxItems: [
            'Home',
            'Gym',
            'Outdoors',
          ],
        ),
        FormFieldData(
          label: 'Other (optional)',
          db_label: 'other',
          keyboardType: TextInputType.text,
        ),
      ],
    ),
    'trainingStyle': FormSectionData(
      title: 'Training Style',
      fields: [
        FormFieldData(
          label: 'Training Style',
          db_label: 'trainingStyle',
          checkboxItems: [
            'Weights',
            'Calisthenics',
            'Crossfit',
            'Cardio',
          ],
        ),
        FormFieldData(
          label: 'Other (optional)',
          db_label: 'other',
          keyboardType: TextInputType.text,
        ),
      ],
    ),
    'other': FormSectionData(
      title: 'Other',
      fields: [
        FormFieldData(
          label: 'Additional Information (optional)',
          db_label: 'additionalInformation',
          keyboardType: TextInputType.text,
        ),
      ],
    ),
  };
}
