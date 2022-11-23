import 'package:flutter/material.dart';

class PrivacyPolc extends StatelessWidget {
  const PrivacyPolc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text('Privacy Policy'),
          centerTitle: true,
        ),
        body: ListView(children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10), 
            child: const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(
              'https://docs.google.com/document/d/1b84bjVoZgMwjdVoK3EczqJwfJY6FC9ltneM2IRcnRr8/edit?usp=sharing')
        ]),
      ),
    );
  }
}
