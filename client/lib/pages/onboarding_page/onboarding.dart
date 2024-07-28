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
      List.generate(13, (_) => TextEditingController());
  late Profile newProfile;
  // I use this so I dont change the profile each time the app builds but only at the first one (Can't be at the init)
  late bool profileInitialized;
  List<Widget> questionPages = [];

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
      PersonalInformationPage(
        controllerList: _controllers.sublist(0, 4),
        onGenderChanged: (String value) {
          newProfile.gender = value;
        },
        initialName: newProfile.name,
        initialAge: newProfile.age != null ? newProfile.age.toString() : null,
        initialGender: newProfile.gender,
      ),
      PersonalMeasuresPage(controllerList: _controllers.sublist(4, 7)),
      ActivityLevelPage(
        onSelected: (String activityLevel) {
          newProfile['activityLevel'] = activityLevel;
        },
        initialValue: newProfile.activityLevel,
      ),
      GoalPage(
        controller: _controllers[7],
        onGoalSelected: (String goal, {bool remove = false}) {
          if (remove) {
            newProfile['goal'].remove(goal);
          } else {
            int index = newProfile.goal!.indexOf(goal);
            if (index == -1) {
              newProfile['goal'].add(goal);
            }
          }
        },
        initialValue: newProfile.goal,
      ),
      DietaryPreferencesPage(
        controller: _controllers[8],
        onSelected: (String value) {
          newProfile.dietaryPreferences = value;
        },
        initialValue: newProfile.dietaryPreferences,
      ),
      NutritionalGoalsPage(
        controller: _controllers[9],
        onGoalSelected: (String nutritionalGoal) {
          newProfile['nutritionalGoals'] = nutritionalGoal;
        },
        initialValue: newProfile.nutritionalGoals,
      ),
      FitnessEnvironmentPage(
        controller: _controllers[10],
        onEnvironmentSelected: (String space, {bool remove = false}) {
          if (remove) {
            newProfile['fitnessEnvironment'].remove(space);
          } else {
            int index = newProfile.fitnessEnvironment!.indexOf(space);
            if (index == -1) {
              newProfile.fitnessEnvironment!.add(space);
            }
          }
        },
        initialValue: newProfile.fitnessEnvironment,
      ),
      TrainingStylesPage(
        controller: _controllers[11],
        onStyleSelected: (String style, {bool remove = false}) {
          if (remove) {
            newProfile['trainingStyle'].remove(style);
          } else {
            int index = newProfile.trainingStyle!.indexOf(style);
            if (index == -1) {
              newProfile.trainingStyle!.add(style);
            }
          }
        },
        initialValue: newProfile.trainingStyle,
      ),
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
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: _nextPage,
            child: Text(
              'Skip',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: PageView.builder(
          controller: _pageController,
          itemCount: questionPages.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: questionPages[index],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80.0),
                    child: ElevatedButton(
                      onPressed: () {
                        questionPages.length - 1 == index
                            ? newCompleteForm(_controllers, newProfile, user,
                                provider, widget.navigator, context)
                            : _nextPage();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        minimumSize: Size(double.infinity, 60),
                      ),
                      child: Text(
                        questionPages.length - 1 == index ? "Done" : "Next",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

void newCompleteForm(
  List<TextEditingController> controllers,
  Profile newProfile,
  User? user,
  MainProvider provider,
  GlobalKey<NavigatorState> navigator,
  BuildContext context,
) async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(user!.uid);
  List<String> missingFields = [];
  // Personal Information
  if (controllers[0].text.isEmpty) {
    missingFields.add("Name");
  }
  if (controllers[1].text.isEmpty) {
    missingFields.add("Lastname");
  }
  if (controllers[2].text.isEmpty) {
    missingFields.add("Age");
  } else {
    newProfile.age = int.parse(controllers[2].text);
  }
  if (newProfile.gender == null) {
    missingFields.add("Gender");
  } else {
    if (newProfile.gender == 'Other') {
      newProfile.gender = controllers[3].text;
    }
  }
  if (controllers[4].text.isEmpty) {
    missingFields.add("Current Weight");
  } else {
    newProfile.currentWeight = double.parse(controllers[4].text);
  }
  if (controllers[5].text.isNotEmpty) {
    newProfile.targetWeight = double.parse(controllers[5].text);
  }
  if (controllers[6].text.isEmpty) {
    missingFields.add("Height");
  } else {
    newProfile.height = double.parse(controllers[6].text);
  }
  if (newProfile.activityLevel == null) {
    missingFields.add("Activity Level");
  }
  if (newProfile.goal!.isEmpty) {
    missingFields.add("Goal");
  } else {
    if (newProfile.goal!.contains("Custom Goal")) {
      int index = newProfile.goal!.indexOf("Custom Goal");
      if (index != -1) {
        newProfile.goal![index] = controllers[7].text;
      }
    }
  }
  if (newProfile.dietaryPreferences == null ||
      newProfile.dietaryPreferences!.isEmpty) {
    missingFields.add("Dietary Preferences");
  }
  if (newProfile.nutritionalGoals == null ||
      newProfile.nutritionalGoals!.isEmpty) {
    missingFields.add("Nutritional Goal");
  }
  if (newProfile.trainingStyle!.isEmpty) {
    missingFields.add("Training Style");
  } else {
    if (newProfile.trainingStyle!.contains("Custom")) {
      int index = newProfile.trainingStyle!.indexOf("Custom");
      if (index != -1) {
        newProfile.trainingStyle![index] = controllers[11].text;
      }
    }
  }
  if (newProfile.fitnessEnvironment!.isEmpty) {
    missingFields.add("Training Style");
  } else {
    if (newProfile.fitnessEnvironment!.contains("Custom")) {
      int index = newProfile.fitnessEnvironment!.indexOf("Custom");
      if (index != -1) {
        newProfile.fitnessEnvironment![index] = controllers[10].text;
      }
    }
  }
  if (missingFields.isEmpty) {
    try {
      newProfile.name =
          user.displayName ?? controllers[0].text + ' ' + controllers[1].text;
      newProfile.onboardingCompleted = true;
      // Update user document in Firestore
      await userDoc.set(newProfile.toMap());
      // ignore: use_build_context_synchronously
      provider.userProfile = newProfile;
      navigator.currentState?.pushReplacementNamed('/home');
    } catch (e) {
      print("Error at sending the onboarding: $e");
      showErrorToast("An error ocurred while saving the onboarding");
      return;
    }
  } else {
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
              // String? value2Delete;
              // for (OnboardingQuestion question in questions) {
              //   if (question.options != null &&
              //       question.allowMultipleSelections == true) {
              //     if (newProfile[question.parameterName]
              //         .any((e) => !question.options!.contains(e))) {
              //       value2Delete = newProfile[question.parameterName]
              //           .firstWhere((e) => !question.options!.contains(e));
              //       newProfile[question.parameterName]
              //           .removeWhere((e) => e == value2Delete);
              //     }
              //   }
              // }
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
