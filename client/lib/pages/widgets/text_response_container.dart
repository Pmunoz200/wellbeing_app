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
    void handleExpandedChange() {
      setState(() {
        isExpanded = !isExpanded;
      });
    }
    return ExpandableCardContainer(
          isExpanded: this.isExpanded,
          collapsedChild: TextResponseContainerWidget(texts: widget.texts, title: widget.title, isExpanded: this.isExpanded, callback: handleExpandedChange),
          expandedChild: TextResponseContainerWidget(texts: widget.texts, title: widget.title, isExpanded: this.isExpanded, callback: handleExpandedChange),
    );
  }
}
  class TextResponseContainerWidget extends StatelessWidget {
    final List<String> texts;
    final String title;
    final bool isExpanded;
    final VoidCallback callback;

    const TextResponseContainerWidget({required this.texts, required this.title, required this.isExpanded, required this.callback});
    @override
    Widget build(BuildContext context) {
      final double aspectRation = isExpanded ? 0.7 : 2;
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
                  child: Stack(
                    fit: StackFit.loose,
                    alignment: Alignment.topRight,
                    children: [
                          Positioned(
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              constraints: BoxConstraints(),
                              onPressed: () {
                              this.callback();
                            }, 
                            icon: Icon(isExpanded ? Icons.zoom_in_map : Icons.zoom_out_map)
                            ),
                          ),
                            Positioned(
                              child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Wrap(
                                    children: [Text('Text $i', style:  Theme.of(context).textTheme.bodyMedium, 
                                    overflow: TextOverflow.ellipsis, 
                                    textAlign: TextAlign.justify,
                                    maxLines: isExpanded ? 100 : 4,),]
                                  ),
                                ),
                            ),
                        ],
                      ),
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