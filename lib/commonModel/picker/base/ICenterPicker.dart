/*
 * @author lsy
 * @date   2020/8/6
 **/
import 'package:flutter/material.dart';
import 'package:flutter_common/commonModel/picker/base/IPicker.dart';

abstract class ICenterPicker extends IPicker {
  Widget build(BuildContext context, int alp);
}
