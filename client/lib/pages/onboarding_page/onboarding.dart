import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gemini_folder/pages/onboarding_page/onboarding_forms.dart';
import 'package:gemini_folder/pages/profile_page/profile_class.dart';
import 'package:gemini_folder/providers/main_provider.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigator;
  final int? focusQuestionIndex;

  const OnboardingScreen(
      {required this.navigator, super.key, this.focusQuestionIndex});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final user = FirebaseAuth.instance.currentUser;
  late PageController _pageController;
  late Profile newProfile;
  bool isLastPage = false;

  // Map to hold the state of each form page
  Map<String, FormStateData> formStates = {};

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();

    // Check if the user is null and navigate to the login screen if true
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.navigator.currentState?.pushReplacementNamed('/authentication');
      });
      return;
    }

    // Initialize newProfile
    newProfile = Profile(
      userId: user!.uid,
      email: user!.email!,
    );

    // Initialize the page controller
    _pageController =
        PageController(initialPage: widget.focusQuestionIndex ?? 0);

    // Initialize formStates with empty states for each page
    final formConfigs = getFormConfigs();
    formStates = {
      for (var entry in formConfigs.entries)
        entry.key: FormStateData(entry.value)
    };

    // Add listener to update isLastPage
    _pageController.addListener(() {
      setState(() {
        isLastPage = (_pageController.page?.round() == formStates.length - 1);
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MainProvider provider = Provider.of<MainProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              if (isLastPage) {
                // Save the data to newProfile
                formStates.forEach((key, state) {
                  print({key: state.toMap()});
                });
              } else {
                _nextPage();
              }
            },
            child: Text(isLastPage ? 'Done' : 'Next'),
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: getFormPages(),
      ),
    );
  }

  List<Widget> getFormPages() {
    return formStates.entries.map((entry) {
      return buildFormPage(entry.value, setState);
    }).toList();
  }
}
