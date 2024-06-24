import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gemini_folder/onboarding/question_class.dart';
import 'package:gemini_folder/onboarding/questions_list.dart';
import 'package:gemini_folder/pages/profile_page/profile_data_list.dart';
import 'package:gemini_folder/pages/profile_page/profile_static_content.dart';
import 'package:gemini_folder/providers/main_provider.dart';
import 'package:gemini_folder/services/auth_service.dart';
import 'package:gemini_folder/services/database_service.dart';
import 'package:gemini_folder/user_authentication/profile_class.dart';
import 'package:gemini_folder/util/toast_util.dart';
import 'package:provider/provider.dart';

class ProfileWidgetPage extends StatefulWidget {
  final GlobalKey<NavigatorState> navigator;

  const ProfileWidgetPage({super.key, required this.navigator});

  @override
  State<ProfileWidgetPage> createState() => _ProfileWidgetPageState();
}

class _ProfileWidgetPageState extends State<ProfileWidgetPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final List<OnboardingQuestion> profileQuestions = questions;
  late Profile userProfile;

  Future<void> _logout() async {
    try {
      final AuthService authService = AuthService();
      await authService.signOut();
      widget.navigator.currentState?.pushReplacementNamed('/authentication');
    } catch (e) {
      if (kDebugMode) {
        print("ERROR DURING LOGOUT: $e");
      }
      showErrorToast("Logout failed. Please try again: $e");
    }
  }

  void getProfile() async {
    try {
      if (user != null) {
        userProfile = (await DatabaseService().getUserProfile(user!.uid))!;
      }
    } catch (e) {
      showErrorToast("Error retrieving the profile: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    MainProvider provider = Provider.of<MainProvider>(context);
    Profile userProfile = provider.userProfile!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProfileTopContent(user: user),
            const Divider(),
            ProfileDataList(
                profileQuestions: profileQuestions, userProfile: userProfile)
          ],
        ),
      ),
    );
  }
}