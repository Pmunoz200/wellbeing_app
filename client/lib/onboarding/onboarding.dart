import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gemini_folder/onboarding/question_class.dart';
import 'package:gemini_folder/user_authentication/profile_class.dart';
import 'package:gemini_folder/util/toast_util.dart';

class OnboardingScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigator;

  const OnboardingScreen({required this.navigator, super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final PageController _pageController = PageController();
  final List<TextEditingController> _controllers = [];
  late Profile newProfile;
  final List<OnboardingQuestion> _questions = [
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

  Widget _buildInputMethod(OnboardingQuestion question, int pageIndex) {
    late Column tempWidget;

    if (question.inputType != null) {
      // question is either a text or a number to write
      tempWidget = Column(
        children: [
          TextField(
            controller: _controllers[pageIndex],
            decoration: InputDecoration(labelText: question.question),
            keyboardType: question.inputType,
          ),
        ],
      );
    } else if (question.options != null &&
        question.allowMultipleSelections == true) {
      // question with single multiple options for an answer
      tempWidget = Column(
        children: [
          Text(question.question),
          ...question.options!.map<Widget>((option) {
            return CheckboxListTile.adaptive(
                title: Text(option),
                value: newProfile[question.parameterName].contains(option),
                onChanged: (bool? newValue) {
                  if (newProfile[question.parameterName].contains(option)) {
                    // add value when picked
                    setState(() {
                      newProfile[question.parameterName].remove(option);
                    });
                  } else {
                    // remove value if already present
                    setState(() {
                      newProfile[question.parameterName].add(option);
                    });
                  }
                });
          })
        ],
      );
      if (question.addCustomField) {
        // Add custom open field on multiple selection
        tempWidget.children.add(CheckboxListTile.adaptive(
            title: newProfile[question.parameterName]
                        .any((e) => !question.options!.contains(e)) &&
                    newProfile[question.parameterName].length > 0
                ? TextField(
                    controller: _controllers[pageIndex],
                    decoration: InputDecoration(
                        labelText: "Custom",
                        enabled: newProfile[question.parameterName]
                                .any((e) => !question.options!.contains(e)) &&
                            newProfile[question.parameterName].length > 0),
                    keyboardType: TextInputType.text,
                  )
                : const Text("Custom"),
            // Check that at least one of the elements of the profile is not in the options
            value: newProfile[question.parameterName]
                    .any((e) => !question.options!.contains(e)) &&
                newProfile[question.parameterName].length > 0,
            onChanged: (bool? newValue) {
              if (!newValue!) {
                // I use the String "Custom" as a flag on the result, to check later
                // the values in the controllers an replace it for the final value
                // of the textField.
                print("OPTIONS: ${question.options}");
                setState(() {
                  newProfile[question.parameterName]
                      .retainWhere((e) => e != "Custom");
                });
              } else {
                setState(() {
                  newProfile[question.parameterName].add("Custom");
                });
              }
            }));
      }
    } else if (question.options != null &&
        question.allowMultipleSelections == false) {
      tempWidget = Column(
        children: [
          Text(question.question),
          ...question.options!.map<Widget>((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              onChanged: (newValue) {
                setState(() {
                  newProfile[question.parameterName] = newValue;
                });
              },
              groupValue: newProfile[question.parameterName],
            );
          })
        ],
      );
      if (question.addCustomField == true) {
        // Add custom open field for single answers of multiple selection
        tempWidget.children.add(RadioListTile<String>(
            title: newProfile[question.parameterName] == "Custom"
                ? TextField(
                    controller: _controllers[pageIndex],
                    keyboardType: TextInputType.text,
                    decoration:
                        const InputDecoration(labelText: "Input Custom"),
                  )
                : const Text("Custom"),
            value: "Custom",
            groupValue: newProfile[question.parameterName],
            onChanged: (newValue) {
              setState(() {
                newProfile[question.parameterName] = newValue;
              });
            }));
      }
    } else {
      tempWidget = const Column(
        children: [
          Text("Missing Question"),
        ],
      );
    }

    return tempWidget;
  }

  void _completeForm() async {
    // Should I separate the concern of communicating with the db
    // on a separate service?
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);
    int pageIndex = 0;
    List<String> missingFields = [];
    for (OnboardingQuestion question in _questions) {
      if (question.inputType != null) {
        // Add to the profile the values from the controllers
        if (_controllers[pageIndex].text.isNotEmpty) {
          newProfile[question.parameterName] = _controllers[pageIndex].text;
        } else {
          if (!question.isOptional) {
            missingFields.add(question.question);
          }
        }
      } else if (question.options != null &&
          question.allowMultipleSelections == true) {
        // Control results for multiple selection
        if (newProfile[question.parameterName].isEmpty &&
            !question.isOptional) {
          if (!question.isOptional) {
            missingFields.add(question.question);
          }
        } else if (newProfile[question.parameterName]
                .any((e) => e == "Custom") &&
            _controllers[pageIndex].text.isNotEmpty) {
          // If there is a flag 'Custom' and the consroller is not empty
          newProfile[question.parameterName].remove((e) => e == "Custom");
          newProfile[question.parameterName].add(_controllers[pageIndex].text);
        } else if (newProfile[question.parameterName]
                .any((e) => e == "Custom") &&
            _controllers[pageIndex].text.isEmpty) {
          if (!question.isOptional) {
            missingFields.add("Custom field: ${question.question}");
          }
        }
      } else if (question.options != null &&
          question.allowMultipleSelections == false) {
        // Control results for single answer multiple options
        if (newProfile[question.parameterName] == null &&
            question.isOptional != true) {
          if (!question.isOptional) {
            missingFields.add(question.question);
          }
        } else if (newProfile[question.parameterName] == "Custom") {
          if (_controllers[pageIndex].text.isNotEmpty) {
            // If there is a custom answer, put it in the profile
            newProfile[question.parameterName] = _controllers[pageIndex].text;
          } else {
            if (!question.isOptional) {
              missingFields.add("Custom field: ${question.question}");
            }
          }
        }
      }
      pageIndex++;
    }
    if (missingFields.isNotEmpty) {
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
              for (var field in missingFields) Text(field),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String? value2Delete;
                for (OnboardingQuestion question in _questions) {
                  if (question.options != null &&
                      question.allowMultipleSelections == true) {
                    if (newProfile[question.parameterName]
                        .any((e) => !question.options!.contains(e))) {
                      value2Delete = newProfile[question.parameterName]
                          .firstWhere((e) => !question.options!.contains(e));
                      newProfile[question.parameterName]
                          .removeWhere((e) => e == value2Delete);
                    }
                  }
                }
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      try {
        newProfile.name = user!.displayName;
        newProfile.onboardingCompleted = true;
        // Update user document in Firestore
        await userDoc.set(newProfile.toMap());
        widget.navigator.currentState?.pushReplacementNamed('/token');
      } catch (e) {
        showErrorToast("An error ocurred while saving the onboarding");
        return;
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
  void initState() {
    super.initState();
    newProfile = Profile.empty(userId: user!.uid, email: user!.email);
    for (var i = 0; i < _questions.length; i++) {
      _controllers.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Onboarding')),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _buildInputMethod(_questions[index], index),
                ),
                ElevatedButton(
                    onPressed: () {
                      _questions.length - 1 == index
                          ? _completeForm()
                          : _nextPage();
                    },
                    child: _questions.length - 1 == index
                        ? const Text("Send onboarding")
                        : const Text("Next")),
              ],
            ),
          );
        },
      ),
    );
  }
}
