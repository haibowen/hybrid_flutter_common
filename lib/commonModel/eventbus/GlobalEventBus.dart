/*
 * @author lsy
 * @date   2019-10-24
 **/
import 'package:event_bus/event_bus.dart';

class GlobalEventBus{
  EventBus event;
  factory GlobalEventBus() => _getInstance();

  static GlobalEventBus get instance => _getInstance();

  static GlobalEventBus _instance;

  GlobalEventBus._internal() {
    // 创建对象
    event = EventBus();
  }

  static GlobalEventBus _getInstance() {
    if (_instance == null) {
      _instance = GlobalEventBus._internal();
    }
    return _instance;
  }
}