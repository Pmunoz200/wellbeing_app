import 'package:flutter/material.dart';
import 'package:gemini_folder/pages/widgets/text_response_container.dart';

const String tryText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap.";
class HomeWidgetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextResponseContainer(text: tryText),
            TextResponseContainer(text: tryText),
          ],
      );
  }
}