import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gemini_folder/pages/onboarding_page/question_class.dart';
import 'package:gemini_folder/pages/onboarding_page/questions_list.dart';
import 'package:gemini_folder/pages/profile_page/profile_static_content.dart';
import 'package:gemini_folder/providers/main_provider.dart';
import 'package:gemini_folder/services/auth_service.dart';
import 'package:gemini_folder/services/database_service.dart';
import 'package:gemini_folder/pages/user_authentication_page/profile_class.dart';
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
  final List<OnboardingQuestion> _questions = questions;
  late Profile userProfile;

  Future<void> _logout(BuildContext context) async {
    try {
      final AuthService authService = AuthService();
      await authService.signOut();
      widget.navigator.currentState?.pushReplacementNamed('/authentication');
    } catch (e) {
      if (kDebugMode) {
        print("ERROR DURING LOGOUT: $e");
      }
      showErrorToast("Logout failed. Please try again.");
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
    Profile userProfile = provider.userProfile;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProfileTopContent(user: user),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  String? value;
                  List<String>? listValues;
                  var parameterValue =
                      userProfile[_questions[index].parameterName];

                  if (parameterValue is String) {
                    value = parameterValue;
                  } else if (parameterValue is int ||
                      parameterValue is double) {
                    value = parameterValue.toString();
                  } else if (parameterValue is List<String>) {
                    listValues = parameterValue;
                  }

                  return listValues == null
                      ? ListTile(
                          title: Text(_questions[index].question),
                          trailing: SizedBox(
                            width: 100,
                            child: Text(
                              value ?? "",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      : ExpansionTile(
                          title: Text(_questions[index].question),
                          children: listValues
                              .map((item) => ListTile(
                                  title: Text(item,
                                      overflow: TextOverflow.ellipsis)))
                              .toList(),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
