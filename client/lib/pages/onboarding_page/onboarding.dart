import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gemini_folder/pages/onboarding_page/onboarding_forms.dart';
import 'package:gemini_folder/pages/user_authentication_page/profile_class.dart';
import 'package:gemini_folder/providers/main_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnboardingScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigator;
  final int? focusQuestionIndex;

  const OnboardingScreen({
    required this.navigator,
    super.key,
    this.focusQuestionIndex,
  });

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

  void _nextPage() async {
    if (isLastPage) {
      _saveOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _saveOnboarding() async {
    // 1. Set completedOnboarding to True
    //newProfile.completedOnboarding = true;

    // 2. Update newProfile with data from formStates
    formStates.forEach((key, state) {
      print(state.toMap());
      newProfile[key] = state.toMap();
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update(newProfile.toMap());

    // 3. Set provider.userProfile to newProfile
    Provider.of<MainProvider>(context, listen: false).userProfile = newProfile;

    // 4. Navigate to the home screen
    //widget.navigator.currentState?.pushReplacementNamed('/home');
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
            onPressed: _saveOnboarding,
            child: Text(isLastPage ? 'Done' : 'Skip'),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: getFormPages(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _nextPage,
              child: Text(isLastPage ? 'Done' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getFormPages() {
    return formStates.entries.map((entry) {
      return buildFormPage(entry.value, setState);
    }).toList();
  }
}
