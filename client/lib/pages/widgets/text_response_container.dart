import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TextResponseContainer extends StatefulWidget {
  final List<String> texts;
  final String title;

  const TextResponseContainer({required this.texts, required this.title});

  @override
  _TextResponseContainerState createState() => _TextResponseContainerState();
}

class _TextResponseContainerState extends State<TextResponseContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(initialPage: widget.texts.length, aspectRatio: 2, enableInfiniteScroll: false, autoPlay: false, viewportFraction: 0.9),
          items: widget.texts.map((i) {
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
                    child: Text('Text $i', style:  Theme.of(context).textTheme.bodyMedium),
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
              widget.title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }
}