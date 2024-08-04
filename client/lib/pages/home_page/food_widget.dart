import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/text_response_container.dart';
import 'package:gemini_folder/chat/message_class.dart';
import 'package:gemini_folder/chat/message_input.dart';
import 'package:gemini_folder/providers/main_provider.dart';
import 'package:provider/provider.dart';

const String tryText = "FOOD Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap.";
const List<String> textList = [tryText, "1" + tryText, "2" + tryText];

class FoodWidgetPage extends StatefulWidget {
  @override
  State<FoodWidgetPage> createState() => _FoodWidgetPageState();
}

class _FoodWidgetPageState extends State<FoodWidgetPage> {
    bool _isSummaryExpanded = false;
  bool _isSuggestionsExpanded = false;
  final mainProvider = MainProvider();
  void toggleSummary() {
    setState(() {
      _isSummaryExpanded = !_isSummaryExpanded;
    });
  }
  bool getSummaryExpandedValue() {
    return _isSummaryExpanded;
  }
  void toggleSuggestions() {
    setState(() {
    _isSuggestionsExpanded = !_isSuggestionsExpanded;
    });
  }
  bool getSuggestionsExpandedValue() {
    return _isSuggestionsExpanded;
  }

  void _sendMessage(MessageObject message) {
    print(message.textMessage);
    mainProvider.sendMessage(FirebaseAuth.instance.currentUser!.uid, message.textMessage ?? "<error_on_request>");
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (context, main, child) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                _isSuggestionsExpanded
                    ? Container()
                    : TextResponseContainer(
                        texts: main.foodSummaryMessages,
                        title: "Summary",
                        getIsExpanded: getSuggestionsExpandedValue,
                        callback: toggleSummary),
                _isSummaryExpanded
                    ? Container()
                    : TextResponseContainer(
                        texts: main.foodSuggestionMessages,
                        title: "Suggestions",
                        getIsExpanded: getSuggestionsExpandedValue,
                        callback: toggleSuggestions,
                      ),
              ])),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: MessageInput(sendMessageFunction: _sendMessage),
          ),
        ],
      ),
    );
    });
  }
}