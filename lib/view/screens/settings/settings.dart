import 'package:flutter/material.dart';
import 'package:musicrythum/controller/provider_db/play_list_db.dart';
 import 'package:musicrythum/view/screens/settings/privacypolicy.dart';

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      onTap: (() {
                        const PrivacyPolc();
                      }),
                      leading: settingstext('Praivacy & Policy'),
                      trailing: IconButton(
                          onPressed: () {
                            const PrivacyPolc();
                          },
                          icon: const Icon(Icons.privacy_tip_sharp)),
                    ),
                    ListTile(
                      onTap: (() {
                        _email();
                      }),
                      leading: settingstext('Feedback'),
                      trailing: IconButton(
                          onPressed: () {
                            _email();
                          },
                          icon: const Icon(Icons.feedback)),
                    ),
                    ListTile(
                        onTap: (() {
                          _about();
                        }),
                        leading: settingstext('About Developer'),
                        trailing: IconButton(
                            onPressed: () {
                              _about();
                            },
                            icon: const Icon(Icons.laptop))),
                    ListTile(
                        onTap: (() {
                          _shareapp();
                        }),
                        leading: settingstext('Share App'),
                        trailing: IconButton(
                            onPressed: () {
                              _shareapp();
                            },
                            icon: const Icon(Icons.share))),
                    ListTile(
                        onTap: (() {
                          resetApplication();
                        }),
                        leading: settingstext('Reset App'),
                        trailing: IconButton(
                            onPressed: () {
                              resetApplication();
                            },
                            icon: const Icon(Icons.restart_alt_sharp))),
                  ],
                ),
              ),
              const Text(
                'Version 1.0.0',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget settingstext(String text) {
    return Text(text,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold));
  }

  Future<void> _about() async {
    // ignore: deprecated_member_use
    if (await launch('https://jishkln.github.io/protfolio-jishnu/')) {
      throw "Try Again";
    }
  }

  Future<void> _email() async {
    // ignore: deprecated_member_use
    if (await launch('mailto:klnjish@gmail.com')) {
      throw "Try Again";
    }
  }

  Future<void> _shareapp() async {
    const applink =
        'https://play.google.com/store/apps/details?id=in.brototype.Musicjabi';
    await Share.share(applink);
  }

  resetApplication() {
    showDialog(
        context: context,
        builder: (i) {
          return AlertDialog(
            title: const Text('Are you Sure ?'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 30, 31, 70),
                    ),
                    child: const Text('NO'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      PlayListDB().appRestart(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 30, 31, 70),
                    ),
                    child: const Text('YES'),
                  ),
                ],
              )
            ],
          );
        });
  }
}
