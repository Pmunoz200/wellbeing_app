import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gemini_folder/pages/home_page/exercise_widget.dart';
import 'package:gemini_folder/pages/widgets/expandable_card_widget.dart';

class TextResponseContainer extends StatefulWidget {
  final List<String> texts;
  final String title;
  final ValueGetter<bool> getIsExpanded;
  final VoidCallback callback;

  TextResponseContainer({required this.texts, required this.title, required this.getIsExpanded, required this.callback});

  @override
  _TextResponseContainerState createState() => _TextResponseContainerState();
}

class _TextResponseContainerState extends State<TextResponseContainer> {
  bool isExpanded = false;
  void initState() {
    super.initState();
    isExpanded = widget.getIsExpanded();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpandableCardContainer(
          isExpanded: this.isExpanded,
          collapsedChild: TextResponseContainerWidget(texts: widget.texts, title: widget.title, isExpanded: this.isExpanded,),
          expandedChild: TextResponseContainerWidget(texts: widget.texts, title: "", isExpanded: this.isExpanded,),
        ),
        MaterialButton(onPressed: () {
          widget.callback();
        }, child: Text("Expand")),
      ],
    );
  }
}
  class TextResponseContainerWidget extends StatelessWidget {
    final List<String> texts;
    final String title;
    final bool isExpanded;

    const TextResponseContainerWidget({required this.texts, required this.title, required this.isExpanded});
    @override
    Widget build(BuildContext context) {
      final double aspectRation = isExpanded ? 1 : 2;
      return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(initialPage: texts.length, aspectRatio: aspectRation, enableInfiniteScroll: false, autoPlay: false, viewportFraction: 0.95),
          items: texts.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(5, 0, 2, 0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Flexible(
                          child: Text('Text $i', style:  Theme.of(context).textTheme.bodyMedium)),
                      ],
                    ),
                  )
                );
              },
            );
          }).toList()),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(right: 16.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
    }
  }