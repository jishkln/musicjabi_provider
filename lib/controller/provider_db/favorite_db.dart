import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteDB extends ChangeNotifier {
  //static ValueNotifier<List<SongModel>> favorite = ValueNotifier([]);
  List<SongModel> favorite = [];
  bool isInitialized = false;
  final favDB = Hive.box<int>('favoriteDB');

  initialise(List<SongModel> songs) {
    for (SongModel song in songs) {
      if (isFavorate(song)) {
        favorite.add(song);
      }
      notifyListeners();
    }
    isInitialized = true;
  }

  bool isFavorate(SongModel song) {
    notifyListeners();
    if (favDB.values.contains(song.id)) {
      return true;
    }
    return false;
  }

  add(SongModel song) async {
    favDB.add(song.id);
    favorite.add(song);
    notifyListeners();
  }

  delete(int id) async {
    notifyListeners();
    int deleteKey = 0;
    if (!favDB.values.contains(id)) {
      return;
    }

    final Map<dynamic, int> favMap = favDB.toMap();
    favMap.forEach((key, value) {
      if (value == id) {
        deleteKey = key;
      }
    });
    favDB.delete(deleteKey);
    favorite.removeWhere((song) => song.id == id);
  }

  notifi() {
    notifyListeners();
  }
}
