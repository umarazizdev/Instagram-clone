import 'package:flutter/cupertino.dart';

class BottomProvider extends ChangeNotifier {
  int selectedIndex = 0;
  void setIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void resetIndex() {
    selectedIndex = 0;
    notifyListeners();
  }
}
