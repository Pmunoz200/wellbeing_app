import 'package:flutter/material.dart';
import 'package:gemini_folder/chat/message_class.dart';
import 'package:gemini_folder/chat/message_input.dart';
import 'package:gemini_folder/pages/widgets/text_response_container.dart';
import 'package:gemini_folder/providers/main_provider.dart';
import 'package:provider/provider.dart';

class GenericWidgetPage extends StatefulWidget {
  final String title;
  final Future<void> Function(MessageObject) sendMessageFunction;

  const GenericWidgetPage({
    Key? key,
    required this.title,
    required this.sendMessageFunction,
  }) : super(key: key);

  @override
  State<GenericWidgetPage> createState() => _GenericWidgetPageState();
}

class _GenericWidgetPageState extends State<GenericWidgetPage> {
  bool _isSummaryExpanded = false;
  bool _isSuggestionsExpanded = false;
  bool _isLoading = false;

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

  Future<void> _sendMessage(MessageObject message) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await widget.sendMessageFunction(message);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (context, mainProvider, child) {
        List<String> summaryMessages;
        List<String> suggestionMessages;

        switch (widget.title) {
          case "Home":
            summaryMessages = mainProvider.homeSummaryMessages;
            suggestionMessages = mainProvider.homeSuggestionMessages;
            break;
          case "Exercise":
            summaryMessages = mainProvider.exerciseSummaryMessages;
            suggestionMessages = mainProvider.exerciseSuggestionMessages;
            break;
          case "Food":
            summaryMessages = mainProvider.foodSummaryMessages;
            suggestionMessages = mainProvider.foodSuggestionMessages;
            break;
          default:
            summaryMessages = ["No messages yet"];
            suggestionMessages = ["No messages yet"];
            break;
        }

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
                            texts: summaryMessages,
                            title: "${widget.title} Summary",
                            getIsExpanded: getSummaryExpandedValue,
                            callback: toggleSummary,
                            isLoading: _isLoading,
                          ),
                    _isSummaryExpanded
                        ? Container()
                        : TextResponseContainer(
                            texts: suggestionMessages,
                            title: "${widget.title} Suggestions",
                            getIsExpanded: getSuggestionsExpandedValue,
                            callback: toggleSuggestions,
                            isLoading: _isLoading,
                          ),
                  ],
                ),
              ),
              if (!_isLoading)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: MessageInput(sendMessageFunction: _sendMessage),
                ),
            ],
          ),
        );
      },
    );
  }
}
