import 'dart:async';

import 'package:flutter/material.dart';
import 'package:musicrythum/view/screens/bottumnavigation/bottom_screen.dart';

class SplashScreanProvider extends ChangeNotifier {
  navigationRoot(context) {
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottumScreen(),
          ),
        );
      },
    );
    notifyListeners();
  }
}
