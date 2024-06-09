import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gemini_folder/onboarding/question_class.dart';

class OnboardingScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigator;

  const OnboardingScreen({required this.navigator, super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final List<TextEditingController> _controllers = [];
  final List<bool> _isAnswerValid = [];
  final List<String?> _selectedOptions = [];

  final List<OnboardingQuestion> _questions = [
    // Personal Information
    OnboardingQuestion(question: 'Name', inputType: TextInputType.text),
    OnboardingQuestion(question: 'Age', inputType: TextInputType.number),
    OnboardingQuestion(
      question: 'Gender',
      options: ['Male', 'Female', 'Other'],
    ),

    // Physical Measurements
    OnboardingQuestion(
      question: 'Current Weight',
      inputType: TextInputType.number,
    ),
    OnboardingQuestion(
      question: 'Target Weight (Optional)',
      inputType: TextInputType.number,
      isOptional: true,
    ),
    OnboardingQuestion(
      question: 'Height',
      inputType: TextInputType.number,
    ),

    // Activity Level
    OnboardingQuestion(
      question: 'Activity Level',
      options: [
        'Sedentary: Little or no exercise',
        'Lightly Active: Light exercise or sports 1-3 days a week',
        'Moderately Active: Moderate exercise or sports 3-5 days a week',
        'Very Active: Hard exercise or sports 6-7 days a week',
        'Super Active: Very hard exercise, physical job, or training twice a day',
      ],
    ),

    // Goal
    OnboardingQuestion(
      question: 'Goal',
      options: [
        'General Health',
        'Lose Weight',
        'Gain Muscle',
        'Body Recomposition (Gain muscle + Lose fat)',
        'Gain Strength',
        'Improve Endurance/Resistance',
        'Custom',
      ],
    ),

    // Dietary Preferences
    OnboardingQuestion(
      question: 'Dietary Preferences',
      options: ['Indifferent', 'Vegetarian', 'Vegan', 'Custom'],
    ),

    // Favorite foods
    OnboardingQuestion(
      question: 'Favorite Foods',
      inputType: TextInputType.text,
    ),

    // Disliked foods
    OnboardingQuestion(
      question: 'Disliked Foods',
      inputType: TextInputType.text,
    ),

    // Meal frequency
    OnboardingQuestion(
      question: 'Meal Frequency',
      inputType: TextInputType.text,
    ),

    // Allergies
    OnboardingQuestion(
      question: 'Allergies',
      inputType: TextInputType.text,
    ),

    // Nutritional Goals
    OnboardingQuestion(
      question: 'Nutritional Goals',
      options: [
        'Let the App Decide',
        'Custom Caloric Intake',
        'Custom',
      ],
    ),

    // Fitness Environment
    OnboardingQuestion(
      question: 'Fitness Environment',
      options: ['Gym Workouts', 'Home Workouts', 'Outdoors', 'Custom'],
    ),

    // Training Style
    OnboardingQuestion(
      question: 'Training Style',
      options: [
        'Calisthenics',
        'Weight Training',
        'Cardio',
        'Crossfit',
        'Custom'
      ],
    ),

    // Sports
    OnboardingQuestion(
      question: 'Sports (Optional)',
      inputType: TextInputType.text,
      isOptional: true,
    ),

    // Medical conditions
    OnboardingQuestion(
      question: 'Medical Conditions (Optional)',
      inputType: TextInputType.text,
      isOptional: true,
    ),

    // Medications
    OnboardingQuestion(
      question: 'Medications (Optional)',
      inputType: TextInputType.text,
      isOptional: true,
    ),
  ];

  Widget _buildQuestionPage(OnboardingQuestion question, int index) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if ((question.inputType == TextInputType.text ||
                  question.inputType == TextInputType.number) &&
              question.options == null) ...[
            TextField(
              controller: _controllers[index],
              decoration: InputDecoration(labelText: question.question),
              keyboardType: question.inputType,
              onChanged: (value) {
                setState(() {
                  _isAnswerValid[index] =
                      value.isNotEmpty || question.isOptional;
                });
              },
            ),
          ],
          if (question.options != null) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(question.question),
                ...question.options!.map((option) {
                  if (option == 'Custom' ||
                      option == 'Optional' ||
                      option == 'Other') {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RadioListTile<String>(
                          title: Text(option),
                          value: option,
                          groupValue: _selectedOptions[index],
                          onChanged: (newValue) {
                            setState(() {
                              _selectedOptions[index] = newValue;
                              _isAnswerValid[index] = true;
                            });
                          },
                        ),
                        if (_selectedOptions[index] == option)
                          TextField(
                            controller: _controllers[index],
                            decoration: InputDecoration(
                              labelText: 'Enter Custom ${question.question}',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _isAnswerValid[index] = value.isNotEmpty;
                              });
                            },
                          ),
                      ],
                    );
                  } else {
                    return RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: _selectedOptions[index],
                      onChanged: (newValue) {
                        setState(() {
                          _selectedOptions[index] = newValue;
                          _isAnswerValid[index] = true;
                        });
                      },
                    );
                  }
                }),
              ],
            ),
          ],
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isAnswerValid[index]
                ? () {
                    if (index == _questions.length - 1) {
                      _completeOnboarding();
                    } else {
                      _nextPage();
                    }
                  }
                : null,
            child: Text(index == _questions.length - 1
                ? 'Complete Onboarding'
                : 'Next'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < _questions.length; i++) {
      _controllers.add(TextEditingController());
      _isAnswerValid.add(_questions[i].isOptional);
      _selectedOptions.add(null);
    }
  }

  void _completeOnboarding() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Initialize a list to store the indices of unanswered non-optional questions
      List<int> unansweredIndices = [];

      // Check if all non-optional questions have valid answers
      bool allNonOptionalQuestionsAnswered = true;
      for (var i = 0; i < _questions.length; i++) {
        if (!_questions[i].isOptional && !_isAnswerValid[i]) {
          // If a non-optional question doesn't have a valid answer, set the flag to false
          allNonOptionalQuestionsAnswered = false;
          // Add the index of the unanswered question to the list
          unansweredIndices.add(i);
        }
      }

      if (allNonOptionalQuestionsAnswered) {
        // If all non-optional questions have valid answers, proceed with completing onboarding
        final data = {
          // Prepare data for updating user document
          for (var i = 0; i < _questions.length; i++)
            _questions[i].question: _controllers[i].text.isEmpty
                ? _selectedOptions[
                    i] // Use selected option if text field is empty
                : _controllers[i].text, // Otherwise, use text field value
          'onboardingCompleted': true,
        };
        // Update user document in Firestore
        await userDoc.update(data);
        // Navigate to the token screen upon successful completion
        widget.navigator.currentState?.pushReplacementNamed('/token');
      } else {
        // If any non-optional question is unanswered, show an alert dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Incomplete Onboarding'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Please complete the following questions:'),
                const SizedBox(height: 8),
                // Display the list of unanswered questions
                for (var index in unansweredIndices)
                  Text(_questions[index].question),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Onboarding')),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          return _buildQuestionPage(_questions[index], index);
        },
      ),
    );
  }
}
