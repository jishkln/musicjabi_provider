import 'package:flutter/foundation.dart';
import 'package:musicrythum/view/screens/home/home_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchProvider extends ChangeNotifier {
  List<SongModel> temp = [];

  searchFile(value) {
    if (value != null && value.isNotEmpty) {
      temp.clear();
      for (SongModel item in HomeScreen.allSongs) {
        if (item.title.toLowerCase().contains(
              value.toLowerCase(),
            )) {
          temp.add(item);
        }
      }
    }
      notifyListeners();
  }
}
