import 'package:flutter/material.dart';

import '../widgets/text_response_container.dart';


const String tryText = "Excercise Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap.";
const List<String> textList = [tryText, "1" + tryText, "2" + tryText];

class ExerciseWidgetPage extends StatefulWidget {
  @override
  State<ExerciseWidgetPage> createState() => _ExerciseWidgetPageState();
}

class _ExerciseWidgetPageState extends State<ExerciseWidgetPage> {
    bool _isSummaryExpanded = false;
  bool _isSuggestionsExpanded = false;
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
    return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _isSuggestionsExpanded ? Container() : TextResponseContainer(texts: textList, title: "Summary", getIsExpanded: getSummaryExpandedValue, callback: toggleSummary),
            _isSummaryExpanded ? Container() : TextResponseContainer(texts: textList, title: "Suggestions", getIsExpanded:  getSuggestionsExpandedValue, callback: toggleSuggestions,),
          ],
      );
  }
}