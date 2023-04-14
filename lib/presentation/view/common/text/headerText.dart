import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final Color color;
  final String text;

  HeaderText(this.color, this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        color: color,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
