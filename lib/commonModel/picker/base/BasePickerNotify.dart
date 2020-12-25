/*
 * @author lsy
 * @date   2020/8/6
 **/
import 'package:flutter/cupertino.dart';
import 'IPicker.dart';

class BasePickerNotify extends ChangeNotifier {
  IPicker iPicker;

  void showNextPicker(IPicker iPicker) {
    this.iPicker = iPicker;
    notifyListeners();
  }

  void dismiss() {
    this.iPicker = null;
    notifyListeners();
  }
}
