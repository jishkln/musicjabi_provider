import 'package:flutter/material.dart';

class TextStyles {
  static const TextStyle subTitleStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal);
  TextStyle titleStyle(
      {required double sizeFont,
      required Color textGradiantColor1,
      required Color textGradiantColor2}) {
    return TextStyle(
      fontSize: sizeFont,
      fontFamily: 'CormorantSC',
      fontWeight: FontWeight.bold,
      foreground: Paint()
        ..shader = LinearGradient(
          colors: <Color>[
            textGradiantColor1,
            textGradiantColor2,
          ],
        ).createShader(
          const Rect.fromLTWH(0.0, 0.0, 300.0, 100.0),
        ),
    );
  }

  TextStyle dilogTextStyle(
      {double? size,
      required Color textColor,
      FontWeight? fontWeight = FontWeight.bold}) {
    return TextStyle(
      fontSize: size,
      fontFamily: 'CormorantSC',
      color: textColor,
      fontWeight: fontWeight,
      wordSpacing: 1,
      letterSpacing: 1,
    );
  }
}
