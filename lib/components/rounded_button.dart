import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final String gender;
  final Function onPressed;
  final Color color;
  final Color textColor;

  RoundedButton(
      {Key key,
      this.text,
      this.gender,
      this.onPressed,
      this.color,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(32),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200,
          height: 42,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
