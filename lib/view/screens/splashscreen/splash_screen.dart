
import 'package:flutter/material.dart';
import 'package:musicrythum/controller/provider/splash_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SplashScreanProvider>(context, listen: false)
          .navigationRoot(context);
    });
    return Scaffold(
      backgroundColor: (Colors.white),
      body: SafeArea(
        child: Center(
          child: Image.asset("asset/images/Music Jabi.gif"),
        ),
      ),
    );
  }
}
