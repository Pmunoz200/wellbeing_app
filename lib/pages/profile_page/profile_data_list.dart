import 'package:flutter/material.dart';
import 'package:gemini_folder/pages/onboarding_page/question_class.dart';
import 'package:gemini_folder/pages/user_authentication_page/profile_class.dart';

class ProfileDataList extends StatelessWidget {
  final List<OnboardingQuestion> profileQuestions;
  final Profile userProfile;

  const ProfileDataList(
      {super.key, required this.profileQuestions, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: profileQuestions.length,
        itemBuilder: (context, index) {
          String? value;
          List<String>? listValues;
          var parameterValue =
              userProfile[profileQuestions[index].parameterName];

          if (parameterValue is String) {
            value = parameterValue;
          } else if (parameterValue is int || parameterValue is double) {
            value = parameterValue.toString();
          } else if (parameterValue is List<String>) {
            listValues = parameterValue;
          }

          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed("/onboarding", arguments: index);
            },
            child: listValues == null
                ? ListTile(
                    title: Text(profileQuestions[index].question),
                    trailing: SizedBox(
                      width: 100,
                      child: Text(
                        value ?? "",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                : ExpansionTile(
                    title: Text(profileQuestions[index].question),
                    children: listValues
                        .map((item) => ListTile(
                            title: Text(item, overflow: TextOverflow.ellipsis)))
                        .toList(),
                  ),
          );
        },
      ),
    );
  }
}
