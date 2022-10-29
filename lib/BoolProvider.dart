import 'package:flutter/material.dart';
class BoolProvider extends ChangeNotifier {
  bool _noBookmarks = false;
  int _indexes = 0;
  bool get noBookmarks {
    return _noBookmarks;
  }
  int get indexes {
    return _indexes;
  }
  Future<bool> setNoBookmarks(bool noBookmarks) async {
    _noBookmarks = noBookmarks;
    notifyListeners();
    return true;
  }
  Future<bool> setBottomChange(int indexes) async {
    _indexes = indexes;
    notifyListeners();
    return true;
  }
}