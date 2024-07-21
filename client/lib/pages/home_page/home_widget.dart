import 'package:flutter/material.dart';
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


  @override
  Widget build(BuildContext context) {
    textList = mainProvider.homeSummaryMessages;
    return Consumer<MainProvider>(
      builder: (context, main, child) {
    return Column(
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
      ],
    );
    });
  }
}
