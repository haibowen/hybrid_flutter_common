/*
 * @author lsy
 * @date   2020/8/6
 **/

import 'package:flutter/material.dart';
import 'package:flutter_common/commonModel/picker/base/BasePickerNotify.dart';

abstract class IPicker{
  void initState(BasePickerNotify dismissCall, BuildContext context);

  void dispose();
}