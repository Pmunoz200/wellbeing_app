import 'package:flutter/material.dart';
import 'package:gemini_folder/user_authentication/profile_class.dart';

class MainProvider with ChangeNotifier {
  Profile userProfile = Profile.empty(userId: "empty Id", email: "empty Email");
}
