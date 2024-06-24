import 'package:flutter/material.dart';

import '../widgets/text_response_container.dart';


const String tryText = "Excercise Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap.";
const List<String> textList = [tryText, "1" + tryText, "2" + tryText];
bool isSummaryExpanded = false;
bool isSuggestionsExpanded = false;
void toggleSummary() {
  isSummaryExpanded = !isSummaryExpanded;
}
bool getSummaryExpandedValue() {
  return isSummaryExpanded;
}
void toggleSuggestions() {
  isSuggestionsExpanded = !isSuggestionsExpanded;
}
bool getSuggestionsExpandedValue() {
  return isSuggestionsExpanded;
}

class ExerciseWidgetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            isSuggestionsExpanded ? Container() : TextResponseContainer(texts: textList, title: "Summary", getIsExpanded: getSummaryExpandedValue, callback: toggleSummary),
            isSummaryExpanded ? Container() : TextResponseContainer(texts: textList, title: "Suggestions", getIsExpanded:  getSuggestionsExpandedValue, callback: toggleSuggestions,),
          ],
      );
  }
}