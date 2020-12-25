/*
 * @author lsy
 * @date   2020-01-16
 **/
class ServerRestore {
  Map<String, String> map = new Map();
  String dioDir;

  ServerRestore._();

  static ServerRestore instance;

  static ServerRestore getInstance() {
    if (instance == null) {
      instance = ServerRestore._();
    }
    return instance;
  }

  Map<String, String> getMap() {
    return map;
  }

}
