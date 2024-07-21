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

  @override
  void initState() {
    super.initState();
    mainProvider.addListener(_onMainProviderChange);
  }

  @override
  void dispose() {
    mainProvider.removeListener(_onMainProviderChange);
    super.dispose();
  }

  void _onMainProviderChange() {
    print("MainProvider changed");
      // Call getHomeWidgetTexts again when MainProvider changes
      // and update the textList
    updateTextList();
  }

  void toggleSummary() {
    setState(() {
      _isSummaryExpanded = !_isSummaryExpanded;
    });
  }

  void updateTextList() {
    setState(() {
      textList = mainProvider.homeMessages;
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
    textList = mainProvider.homeMessages;
    return Consumer<MainProvider>(
      builder: (context, main, child) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _isSuggestionsExpanded
            ? Container()
            : TextResponseContainer(
                texts: main.homeMessages,
                title: "Summary",
                getIsExpanded: getSuggestionsExpandedValue,
                callback: toggleSummary),
        _isSummaryExpanded
            ? Container()
            : TextResponseContainer(
                texts: textList,
                title: "Suggestions",
                getIsExpanded: getSuggestionsExpandedValue,
                callback: toggleSuggestions,
              ),
      ],
    );
    });
  }
}
