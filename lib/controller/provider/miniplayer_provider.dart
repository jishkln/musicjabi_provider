import 'package:flutter/foundation.dart';
import 'package:musicrythum/controller/widgets/song_storage.dart';

class MiniPlayerProvider extends ChangeNotifier {
  checkMiniPlayer() {
    Songstorage.player.currentIndexStream.listen((index) {
      if (index != null) {
        notifyListeners();
      }
    });
  }
}
