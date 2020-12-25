/*
 * @author lsy
 * @date   2019-09-05
 **/
import 'dart:async';

class LiveData<T> {
  StreamController<T> _controller;
  T data;

  LiveData() {
    this._controller = new StreamController<T>.broadcast();
  }

  get stream => _controller.stream;

  get controller => _controller;

  void notifyView(T t) {
    this.data = t;
    if (!_controller.isClosed) {
      _controller.sink.add(t);
    }
  }

  void dispost() {
    data = null;
    _controller.close();
  }
}
