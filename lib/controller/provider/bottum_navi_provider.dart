import 'package:flutter/foundation.dart';

class BottumNaviProvider extends ChangeNotifier {
  int _cutterntIndex = 0;

  get getIndex => _cutterntIndex;

  set setIndex(index) {
    _cutterntIndex = index;
    notifyListeners();
  }
}
