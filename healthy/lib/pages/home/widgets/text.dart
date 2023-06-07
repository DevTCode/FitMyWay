import 'package:flutter/material.dart';

class text extends StatelessWidget {
  double fontSize;
  String titleText;
  text(this.fontSize, this.titleText, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      titleText,
      style: TextStyle(
          color: Color.fromARGB(255, 41, 149, 189),
          fontSize: fontSize,
          letterSpacing: 2,
          fontWeight: FontWeight.bold),
    );
  }
}
