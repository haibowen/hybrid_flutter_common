/*
 * @author lsy
 * @date   2019-09-02
 **/
import 'dart:math';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:flutter_common/Annotations/anno/Router.dart';
import 'package:flutter_common/Annotations/base/RouterBuildItem.dart';
import 'package:source_gen/source_gen.dart';

import '../RouterCenterRestore.dart';

class RouterGenerator extends GeneratorForAnnotation<Router> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    var modelName = annotation.peek("modelName").stringValue;
    var typeValue = annotation.peek("impl").typeValue;
    var resignThisModel = annotation.peek("resignThisModel").boolValue;
    var pathSegments = buildStep.inputId.pathSegments;
    StringBuffer buffer = new StringBuffer();
    String interfaceName;
    for (int i = 0; i < pathSegments.length; i++) {
      if (pathSegments[i] != "lib" && i != pathSegments.length - 1) {
        buffer.write(pathSegments[i] + "/");
      } else if (i == pathSegments.length - 1) {
//        buffer.write("${typeValue.name}.dart");
        interfaceName = pathSegments[i].replaceAll(".dart", "");
      }
    }
    String first =
        "import \"package:${buildStep.inputId.package}/${buffer.toString()}";
    String second = typeValue.name;
    String third = interfaceName;
    bool four = resignThisModel;
    RouterBuildItem item = new RouterBuildItem(first, second, third, four);

    if (RouterCenterRestore().buildMap[modelName] != null) {
      throw Exception("router error have same model name !!! change it name ");
    }

    RouterCenterRestore().buildMap.putIfAbsent(modelName, () => item);

//    return """
////    import ${"package:${buildStep.inputId.package}/${buildStep.inputId.path.replaceFirst('lib/', '')}"}
//      class APT {
//        Map<String,RouterBaser> map={};
//      }
//      """;
    return null;
  }
}
