import 'package:flutter/material.dart';
import 'package:gemini_folder/pages/user_authentication_page/profile_class.dart';
import 'package:gemini_folder/services/gemini_service/api_service.dart';
import 'package:gemini_folder/services/gemini_service/conversation_model.dart';

class MainProvider with ChangeNotifier {
  Profile? userProfile;

  // ConversationModel object to store the current conversation
  ConversationModel? currentConversations = ConversationModel(
          conversation: [],
        );

  // Method to fetch the user conversation for a specific date
  void fetchMessagesAndUpdateThem(String uid, DateTime date) async {
    try{
      final ApiService apiService = ApiService(baseUrl: 'http://127.0.0.1:5001/wellbeing-app-d5a53/us-central1');
      currentConversations = await apiService.getUserMessagesByDate(uid, date);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
