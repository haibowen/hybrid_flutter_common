/*
 * @author lsy
 * @date   2019-09-02
 **/
import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:flutter_common/Annotations/anno/RouterCenter.dart';
import 'package:source_gen/source_gen.dart';

import '../RouterCenterRestore.dart';

class RouterCenterGenerator extends GeneratorForAnnotation<RouterCenter> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    StringBuffer buffer = new StringBuffer();
    StringBuffer importBuffer = new StringBuffer();
    StringBuffer annoBuffer = new StringBuffer();
    StringBuffer funBuffer = new StringBuffer();
    RouterCenterRestore().buildMap.forEach((f, s) {
      if (s.four) {
        buffer.write("map.putIfAbsent(\"${f}\", ()=>${s.second}());\n");
      }
      annoBuffer.write("//${s.second} is resign : ${s.four} \n");
      importBuffer.write("${s.first}${s.second}.dart\";\n");
      importBuffer.write("${s.first}${s.third}.dart\";\n");
      funBuffer.write("""
        ${s.third} find${s.third}(){
          if(map[\"${f}\"]==null){
            return null;
          }
          return map[\"${f}\"] as ${s.third};
        }
      """);
    });

    var pathSegments = buildStep.inputId.pathSegments;
    StringBuffer pathBuffer = new StringBuffer();
    for (int i = 0; i < pathSegments.length; i++) {
      if (pathSegments[i] != "lib" && i != pathSegments.length - 1) {
        pathBuffer.write(pathSegments[i] + "/");
      }
    }
    String sufPath = pathBuffer.toString();
//    import "${"package:${buildStep.inputId.package}/${sufPath}RouterCenterRestore.dart"}";
    //import "${"package:${buildStep.inputId.package}/${sufPath}RouterBaser.dart"}";
    return """
    ${annoBuffer.toString()}
    ${importBuffer.toString()}
    import "${"package:flutter_common/Annotations/RouterBaser.dart"}";
      class RouterCenterImpl {
         
        Map<String,RouterBaser> map;
        
        factory RouterCenterImpl() => _sharedInstance();

        static RouterCenterImpl _instance;

        RouterCenterImpl._() {
          if (map == null) {
            map = new Map();
            init();
          } else {
            throw Exception("too many RouterCenter instance!!!  fix it ");
          }
        }

        static RouterCenterImpl _sharedInstance(){
          if (_instance == null) {
            _instance = RouterCenterImpl._();
          }
          return _instance;
        }

        void init(){
          ${buffer.toString()}
        }
        
        RouterBaser getModel(String modelName){
          return map[modelName];
        }
        
        ${funBuffer.toString()}
        
        
      }
      """;
  }
}
