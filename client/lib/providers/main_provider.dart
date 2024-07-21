import 'package:flutter/material.dart';
import 'package:gemini_folder/pages/user_authentication_page/profile_class.dart';
import 'package:gemini_folder/services/gemini_service/api_service.dart';
import 'package:gemini_folder/services/gemini_service/conversation_model.dart';
import 'dart:async';

final String BASEURL = 'http://127.0.0.1:5001/wellbeing-app-d5a53/us-central1';
class MainProvider with ChangeNotifier {
  Profile? userProfile;

  // ConversationModel object to store the current conversation
  ConversationModel? currentConversations = ConversationModel(
          conversation: [],
        );

  // Method to fetch the user conversation for a specific date
  Future<void> fetchMessagesAndUpdateThem(String uid, DateTime date) async {
    try{
      final ApiService apiService = ApiService(baseUrl: BASEURL);
      currentConversations = await apiService.getUserMessagesByDate(uid, date);
      getHomeWidgetTexts(); // Call getHomeWidgetTexts to update the homeMessages
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  List<String> homeSummaryMessages = [];
  List<String> homeSuggestionMessages = [];
  void getHomeWidgetTexts() {
    if (currentConversations != null) {
      print(currentConversations!.toJson());
      final modelMessageList = currentConversations!.conversation
          .where((element) => element.role == "model");
      List<String> returnSummaryMessageList = [];
      List<String> returnSuggestionList = [];
      for (var message in modelMessageList) {
        returnSummaryMessageList.add(message.content.summary);
        returnSuggestionList.add(message.content.suggestion);
      }
      homeSummaryMessages = returnSummaryMessageList;
      homeSuggestionMessages = returnSuggestionList;
      notifyListeners();
    }
  }

}
