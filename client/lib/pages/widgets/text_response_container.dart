import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gemini_folder/pages/widgets/expandable_card_widget.dart';

class TextResponseContainer extends StatefulWidget {
  final List<String> texts;
  final String title;
  final ValueGetter<bool> getIsExpanded;
  final VoidCallback callback;
  final bool isLoading;

  const TextResponseContainer(
      {super.key,
      required this.texts,
      required this.title,
      required this.getIsExpanded,
      required this.callback,
      required this.isLoading});

  @override
  State<TextResponseContainer> createState() => _TextResponseContainerState();
}

class _TextResponseContainerState extends State<TextResponseContainer> {
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.getIsExpanded();
  }

  @override
  Widget build(BuildContext context) {
    void handleExpandedChange() {
      widget.callback();
      setState(() {
        isExpanded = !isExpanded;
      });
    }

    return ExpandableCardContainer(
      isExpanded: this.isExpanded,
      collapsedChild: TextResponseContainerWidget(
          texts: widget.texts,
          title: widget.title,
          isExpanded: this.isExpanded,
          callback: handleExpandedChange,
          isLoading: widget.isLoading),
      expandedChild: TextResponseContainerWidget(
          texts: widget.texts,
          title: widget.title,
          isExpanded: this.isExpanded,
          callback: handleExpandedChange,
          isLoading: widget.isLoading),
    );
  }
}

class TextResponseContainerWidget extends StatelessWidget {
  final List<String> texts;
  final String title;
  final bool isExpanded;
  final VoidCallback callback;
  final bool isLoading;

  const TextResponseContainerWidget(
      {required this.texts,
      required this.title,
      required this.isExpanded,
      required this.callback,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final double aspectRatio = isExpanded ? 0.7 : 2;

    return Column(
      children: [
        isLoading
            ? Center(child: CircularProgressIndicator())
            : CarouselSlider(
                options: CarouselOptions(
                    initialPage: texts.length,
                    aspectRatio: aspectRatio,
                    enableInfiniteScroll: false,
                    autoPlay: false,
                    viewportFraction: 0.95),
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
                          child: Container(
                              padding: EdgeInsets.all(12), child: Text('$i')));
                    },
                  );
                }).toList(),
              ),
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
