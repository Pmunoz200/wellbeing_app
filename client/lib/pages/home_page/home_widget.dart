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
  String tryText =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap.";
  List<String> textList = [];

  bool _isSummaryExpanded = false;
  bool _isSuggestionsExpanded = false;
  final mainProvider = MainProvider();
  List<String> textList = [""];

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
    String textMessage = message.textMessage ?? "No text message";
  }

  @override
  void initState() {
    super.initState();
    textList = [tryText, "1" + tryText, "2" + tryText];
  }


  @override
  Widget build(BuildContext context) {
    textList = mainProvider.homeSummaryMessages;
    return Consumer<MainProvider>(
      builder: (context, main, child) {
    return Column(
      children: [
        Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
              _isSuggestionsExpanded
                  ? Container()
                  : TextResponseContainer(
                      texts: main.homeSummaryMessages,
                      title: "Summary",
                      getIsExpanded: getSuggestionsExpandedValue,
                      callback: toggleSummary),
              _isSummaryExpanded
                  ? Container()
                  : TextResponseContainer(
                      texts: main.homeSuggestionMessages,
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
    );
    });
  }
}
