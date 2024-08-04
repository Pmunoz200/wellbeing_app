import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gemini_folder/pages/onboarding_page/onboarding_form.dart';
import 'package:gemini_folder/pages/onboarding_page/onboarding_sections.dart';
import 'package:gemini_folder/pages/profile_page/formPage.dart';
import 'package:gemini_folder/pages/user_authentication_page/profile_class.dart';
import 'package:gemini_folder/providers/main_provider.dart';
import 'package:gemini_folder/services/auth_service.dart';
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
  late Profile userProfile;
  bool _isInitialized = false; // Added initialization flag

  // Map to hold the state of each form page
  Map<String, FormStateData> formStates = {};
  Map<String, String> formTitles = {};

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

  void initializeFormStates() {
    final formConfigs = getFormConfigs();
    formStates = formConfigs.map((key, section) {
      return MapEntry(key, FormStateData(section.fields));
    });
    formTitles =
        formConfigs.map((key, section) => MapEntry(key, section.title));

    formConfigs.forEach((key, section) {
      final formState = formStates[key]!;
      final profileData = userProfile[key] as Map<String, dynamic>;

      for (var field in section.fields) {
        if (field.dropdownItems != null) {
          formState.dropdownValues[field.db_label] =
              profileData[field.db_label];
        } else if (field.checkboxItems != null) {
          formState.checkboxValues[field.db_label] = field.checkboxItems!
              .map((item) =>
                  profileData[field.db_label]?.contains(item) ?? false)
              .toList()
              .cast<bool>();
        } else {
          formState.textControllers[field.db_label]?.text =
              profileData[field.db_label]?.toString() ?? '';
        }
      }
    });
  }

  void _saveOnboarding() async {
    formStates.forEach((key, state) {
      userProfile[key] = state.toMap();
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update(userProfile.toMap());

    // Update provider with new profile
    Provider.of<MainProvider>(context, listen: false).userProfile = userProfile;
  }

  void _updateFormState(String key, FormStateData updatedFormState) {
    setState(() {
      formStates[key] = updatedFormState;
    });
    _saveOnboarding();
  }

  void _showFormPage(String key, String title) {
    final formState = formStates[key];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FormPageWidget(formState: formState!, title: title),
      ),
    ).then((_) {
      setState(() {
        formStates.forEach((key, state) {
          print(state.toMap());
        });
        _saveOnboarding();
      }); // Ensure state is updated when returning to the profile page
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MainProvider provider = Provider.of<MainProvider>(context);

    if (provider.userProfile == null) {
      return Center(child: CircularProgressIndicator());
    }

    if (!_isInitialized) {
      userProfile = provider.userProfile!;
      initializeFormStates();
      _isInitialized = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(),
          ),
        ],
      ),
      body: ListView(
        children: formTitles.entries.map((entry) {
          return InkWell(
            onTap: () => _showFormPage(entry.key, entry.value),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  entry.value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
