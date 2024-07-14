import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gemini_folder/pages/onboarding_page/question_class.dart';
import 'package:gemini_folder/pages/onboarding_page/question_pages/activity_level.dart';
import 'package:gemini_folder/pages/onboarding_page/question_pages/dietary_preferences.dart';
import 'package:gemini_folder/pages/onboarding_page/question_pages/fitness_enviroment.dart';
import 'package:gemini_folder/pages/onboarding_page/question_pages/goals.dart';
import 'package:gemini_folder/pages/onboarding_page/question_pages/nutritional_goal.dart';
import 'package:gemini_folder/pages/onboarding_page/question_pages/other.dart';
import 'package:gemini_folder/pages/onboarding_page/question_pages/personal_information.dart';
import 'package:gemini_folder/pages/onboarding_page/question_pages/personal_measurments.dart';
import 'package:gemini_folder/pages/onboarding_page/question_pages/training_style.dart';
import 'package:gemini_folder/pages/onboarding_page/questions_list.dart';
import 'package:gemini_folder/providers/main_provider.dart';
import 'package:gemini_folder/pages/user_authentication_page/profile_class.dart';
import 'package:gemini_folder/util/toast_util.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigator;
  final int?
      focusQuestionIndex; // Optionally, you can pass the index of the question to start on.

  const OnboardingScreen(
      {required this.navigator, super.key, this.focusQuestionIndex});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final user = FirebaseAuth.instance.currentUser;
  late PageController _pageController;
  final List<TextEditingController> _controllers =
      List<TextEditingController>.filled(13, TextEditingController());
  late Profile newProfile;
  // I use this so I dont change the profile each time the app builds but only at the first one (Can't be at the init)
  late bool profileInitialized;
  List<Widget> questionPages = [];
  List<String> selectedGoals = [];
  List<String> selectedDietaryPreferences = [];

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    profileInitialized = false;
    newProfile = Profile.empty(userId: user!.uid, email: user!.email);
    questionPages.addAll([
      PersonalInformationPage(controllerList: _controllers.sublist(0, 4)),
      PersonalMeasuresPage(controllerList: _controllers.sublist(4, 7)),
      ActivityLevelPage(onSelected: (String activityLevel) {
        newProfile['activityLevel'] = activityLevel;
      }),
      GoalPage(
          controller: _controllers[7],
          onGoalSelected: (String goal, {bool remove = false}) {
            if (remove) {
              newProfile['goal'].remove(goal);
            } else {
              newProfile['goal'].add(goal);
            }
          }),
      DietaryPreferencesPage(
          controller: _controllers[8],
          onPreferenceSelected: (String preference, {bool remove = false}) {
            setState(() {
              if (remove) {
                selectedDietaryPreferences.remove(preference);
              } else {
                selectedDietaryPreferences.add(preference);
              }
            });
          }),
      NutritionalGoalsPage(
          controller: _controllers[9],
          onGoalSelected: (String nutritionalGoal) {
            newProfile['nutritionalGoals'] = nutritionalGoal;
          }),
      FitnessEnvironmentPage(
          controller: _controllers[10],
          onEnvironmentSelected: (String space, {bool remove = false}) {
            if (remove) {
              newProfile['fitnessEnvironment'].remove(remove);
            } else {
              newProfile['fitnessEnvironment'].add(remove);
            }
          }),
      TrainingStylesPage(
          controller: _controllers[11],
          onStyleSelected: (String style, {bool remove = false}) {
            if (remove) {
              newProfile['trainingStyle'].remove(style);
            } else {
              newProfile['trainingStyle'].add(remove);
            }
          }),
      OthersPage(
          controller: _controllers[12],
          onSubmitted: (String other) {
            newProfile['other'] = other;
          })
      // ADD THE OTHER PAGES
    ]);

    _pageController =
        PageController(initialPage: widget.focusQuestionIndex ?? 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MainProvider provider = Provider.of<MainProvider>(context, listen: false);
    if (provider.userProfile != null && !profileInitialized) {
      newProfile = provider.userProfile!;
      int questionIndex = 0;
      for (OnboardingQuestion question in questions) {
        // Set the values on the controllers to the selected ones;
        if (question.inputType != null &&
            newProfile[question.parameterName] != null) {
          if (question.inputType == TextInputType.text) {
            _controllers[questionIndex].text =
                newProfile[question.parameterName] ?? "";
          } else {
            _controllers[questionIndex].text =
                newProfile[question.parameterName].toString();
          }
        } else if (question.options != null &&
            question.allowMultipleSelections) {
          if (question.addCustomField &&
              newProfile[question.parameterName]
                  .any((e) => !question.options!.contains(e))) {
            // If there is a custom field (which is known as it is not contained on the options)
            // put it in the controller and substitute it for the "Custom" flag;
            String customValue = newProfile[question.parameterName]
                .firstWhere((e) => !question.options!.contains(e));
            _controllers[questionIndex].text = customValue;
            newProfile[question.parameterName]
                .removeWhere((e) => e == customValue);
            newProfile[question.parameterName].add("Custom");
          }
          //Add the possibility for a question with options but no multiple selection
          // to add the custom field selection, the value in the controller, and set the
          // "Custom" flag
        } else if (question.options != null &&
            !question.allowMultipleSelections) {
          if (question.addCustomField &&
              !question.options!.contains(newProfile[question.parameterName])) {
            _controllers[questionIndex].text =
                newProfile[question.parameterName];
            newProfile[question.parameterName] = "Custom";
          }
        }
        questionIndex++;
      }
      setState(() {
        profileInitialized = true;
      });
    }

    return Scaffold(
      appBar: provider.userProfile != null ? AppBar() : null,
      body: PageView.builder(
        controller: _pageController,
        itemCount: questionPages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: questionPages[index],
                ),
                ElevatedButton(
                    onPressed: () {
                      // _questions.length - 1 == index
                      //     ? _completeForm(provider, user, _controllers,
                      //         _questions, newProfile, context, widget.navigator):
                      _nextPage();
                    },
                    // child: _questions.length - 1 == index
                    //     ? const Text("Send onboarding")
                    //     : const Text("Next")),
                    child: Text("Next")),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Function to complete the form and navigate to another page
void _completeForm(
    MainProvider provider,
    User? user,
    List<TextEditingController> controllers,
    List<OnboardingQuestion> questions,
    Profile newProfile,
    BuildContext context,
    GlobalKey<NavigatorState> navigator) async {
  // Should I separate the concern of communicating with the db
  // on a separate service?
  final userDoc = FirebaseFirestore.instance.collection('users').doc(user!.uid);
  int pageIndex = 0;
  List<String> missingFields = [];
  for (OnboardingQuestion question in questions) {
    if (question.inputType != null) {
      // Add to the profile the values from the controllers
      if (controllers[pageIndex].text.isNotEmpty) {
        newProfile[question.parameterName] = controllers[pageIndex].text;
      } else {
        if (!question.isOptional) {
          missingFields.add(question.question);
        }
      }
    } else if (question.options != null &&
        question.allowMultipleSelections == true) {
      // Control results for multiple selection
      if (newProfile[question.parameterName].isEmpty && !question.isOptional) {
        if (!question.isOptional) {
          missingFields.add(question.question);
        }
      } else if (newProfile[question.parameterName].any((e) => e == "Custom") &&
          controllers[pageIndex].text.isNotEmpty) {
        // If there is a flag 'Custom' and the consroller is not empty
        newProfile[question.parameterName].removeWhere((e) => e == "Custom");
        newProfile[question.parameterName].add(controllers[pageIndex].text);
      } else if (newProfile[question.parameterName].any((e) => e == "Custom") &&
          controllers[pageIndex].text.isEmpty) {
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
        if (controllers[pageIndex].text.isNotEmpty) {
          // If there is a custom answer, put it in the profile
          newProfile[question.parameterName] = controllers[pageIndex].text;
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
              for (OnboardingQuestion question in questions) {
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
      newProfile.name = user.displayName;
      newProfile.onboardingCompleted = true;
      // Update user document in Firestore
      await userDoc.set(newProfile.toMap());
      // ignore: use_build_context_synchronously
      provider.userProfile = newProfile;
      navigator.currentState?.pushReplacementNamed('/home');
    } catch (e) {
      showErrorToast("An error ocurred while saving the onboarding");
      return;
    }
  }
}
