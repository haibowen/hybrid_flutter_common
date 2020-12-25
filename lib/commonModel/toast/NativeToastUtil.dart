/*
 * @author lsy
 * @date   2020/5/8
 **/
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NativeToastUtil {
  static int lastTime;
  static String lastWorld;

  static void showNativeToast(String text) {
    showNativeToastWithTime(text, false);
  }

  static void showNativeToastWithTime(String text, bool long) {
    if (text == null) {
      text = "null";
    }
    if (lastTime != null &&
        lastWorld != null &&
        DateTime.now().millisecondsSinceEpoch - lastTime < 1000 &&
        lastWorld == text) {
      return;
    }
    lastTime = DateTime.now().millisecondsSinceEpoch;
    lastWorld = text;
    Fluttertoast.showToast(
        msg: text,
        toastLength: long ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xcc000000),
        textColor: Colors.white,
        fontSize: 15.0);
  }
}
