import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gemini_folder/chat/message_class.dart';
import 'package:gemini_folder/chat/message_input.dart';
import 'package:gemini_folder/pages/widgets/text_response_container.dart';
import 'package:gemini_folder/providers/main_provider.dart';
import 'package:provider/provider.dart';

class HomeWidgetPage extends StatefulWidget {
  HomeWidgetPage({Key? key}) : super(key: key);

  @override
  State<HomeWidgetPage> createState() => _HomeWidgetPageState();
}

class _HomeWidgetPageState extends State<HomeWidgetPage> {

  bool _isSummaryExpanded = false;
  bool _isSuggestionsExpanded = false;
  final mainProvider = MainProvider();
  List<String> textList = ["No messages yet"];

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
  void initState() {
    super.initState();
    print("HomeWidgetPage initState");
    mainProvider.getHomeWidgetTexts();
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
                        texts: main.homeSummaryMessages.isEmpty ? textList : main.homeSummaryMessages,
                        title: "Summary",
                        getIsExpanded: getSuggestionsExpandedValue,
                        callback: toggleSummary),
                _isSummaryExpanded
                    ? Container()
                    : TextResponseContainer(
                        texts: main.homeSuggestionMessages.isEmpty ? textList : main.homeSuggestionMessages,
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
