import 'package:flutter/foundation.dart';
import 'package:musicrythum/controller/widgets/song_storage.dart';

class PlayScreenProvider extends ChangeNotifier {
  int currentIndex = 0;

  checkSongIndex() {
    Songstorage.player.currentIndexStream.listen(
      (index) {
        if (index != null) {
          currentIndex = index;

          Songstorage.currentIndexx = index;
        }
          notifyListeners();
      },
    );
  }
}
