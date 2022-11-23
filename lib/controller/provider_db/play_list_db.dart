import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicrythum/model/musicplayer_model.dart';
import 'package:musicrythum/view/screens/splashscreen/splash_screen.dart';

class PlayListDB extends ChangeNotifier {
  // ValueNotifier<List<MusicPlayeerModel>> playListNotifier = ValueNotifier([]);

  final List<MusicPlayeerModel> playListNotif = [];

  // final playListDB = Hive.openBox<MusicPlayeerModel>('playlistDB');

  Future<void> playListAdd(MusicPlayeerModel value) async {
    final playListDB = Hive.box<MusicPlayeerModel>('playlistDB');

    await playListDB.add(value);
    getAllPlayList();
    notifyListeners();

    // playListNotifier.value.add(value);
  }

  Future<void> getAllPlayList() async {
    final playListDB = Hive.box<MusicPlayeerModel>('playlistDB');

    playListNotif.clear();
    playListNotif.addAll(playListDB.values);

    notifyListeners();
  }

  Future<void> playListDelete(int index) async {
    final playListDB = Hive.box<MusicPlayeerModel>('playlistDB');

    await playListDB.deleteAt(index);
    getAllPlayList();
    notifyListeners();
  }

  Future<void> appRestart(context) async {
    final playListDB = Hive.box<MusicPlayeerModel>('playlistDB');

    final favDB = Hive.box<int>('favoriteDB');
    await favDB.clear();
    await playListDB.clear();
    favDB.clear();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
        (route) => false);
  }

  notif() {
    notifyListeners();
  }
}
