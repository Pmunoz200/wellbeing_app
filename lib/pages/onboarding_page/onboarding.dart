import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gemini_folder/pages/onboarding_page/question_class.dart';
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
  final List<TextEditingController> _controllers = [];
  late Profile newProfile;
  final List<OnboardingQuestion> _questions = questions;

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

  void _completeForm(MainProvider provider) async {
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
        // ignore: use_build_context_synchronously
        provider.userProfile = newProfile;
        widget.navigator.currentState?.pushReplacementNamed('/home');
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
    if (provider.userProfile != null) {
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
          //TODO: Add the possibility for a question with options but no multiple selection
          // to add the custom field selection, the value in the controller, and set the 
          // "Custom" flag
        }
        questionIndex++;
      }
    }

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
                          ? _completeForm(provider)
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
