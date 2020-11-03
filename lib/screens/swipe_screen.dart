import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';

class SwipeScreen extends StatefulWidget {
  static String id = 'scroll_screen';
  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  CardController controller;
  List<String> profileImages = [
    'images/blanprofile.png',
    'images/Fish_logo.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: TinderSwapCard(
          totalNum: 2,
          stackNum: 2,
          maxHeight: MediaQuery.of(context).size.width * 0.9,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          minWidth: MediaQuery.of(context).size.width * 0.8,
          minHeight: MediaQuery.of(context).size.width * 0.8,
          swipeEdge: 4.0,
          orientation: AmassOrientation.BOTTOM,
          cardBuilder: (BuildContext context, int index) => Card(
            child: Image.asset('${profileImages[index]}'),
          ),
          //cardController: controller = CardController(),
        ),
      ),
    );
  }
}
