/*
 * @author lsy
 * @date   2020-01-16
 **/
import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:flutter_common/Annotations/anno/DioEntity.dart';
import 'package:flutter_common/Annotations/restore/ServerRestore.dart';
import 'package:source_gen/source_gen.dart';

class DioGenerator extends GeneratorForAnnotation<DioEntity> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
          "Request class is not ok for ${element.displayName}");
    }
    ClassElement classElement = (element as ClassElement);
    StringBuffer dir = StringBuffer();
    dir.write("import 'package:");
    List<String> dirlist = classElement.enclosingElement.toString().split("/");
    for (int i = 1; i < dirlist.length; i++) {
      if (i != 2) {
        dir.write(dirlist[i]);
        if (i != dirlist.length - 1) {
          dir.write("/");
        }
      }
    }
    dir.write("';\n");
    print("dir  ${dir}");
    ServerRestore.getInstance().dioDir = dir.toString();
    return null;
  }
}
