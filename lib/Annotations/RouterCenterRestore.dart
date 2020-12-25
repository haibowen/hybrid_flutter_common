/*
 * @author lsy
 * @date   2019-09-02
 **/

import 'anno/RouterCenter.dart';
import 'base/RouterBuildItem.dart';

class RouterCenterRestore {
  Map<String, RouterBuildItem> buildMap;

  factory RouterCenterRestore() => _sharedInstance();

  static RouterCenterRestore _instance;

  RouterCenterRestore._() {
    if (buildMap == null) {
      buildMap = new Map();
    } else {
      throw Exception("too many RouterCenter instance!!!  fix it ");
    }
  }

  static RouterCenterRestore _sharedInstance() {
    if (_instance == null) {
      _instance = RouterCenterRestore._();
    }
    return _instance;
  }
}
