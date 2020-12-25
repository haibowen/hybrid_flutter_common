/*
 * @author lsy
 * @date   2019-09-02
 **/

library Router;

class Router {
  final String modelName;
  final Type impl;
  final bool resignThisModel;

  const Router(this.modelName, this.impl, this.resignThisModel);
}
