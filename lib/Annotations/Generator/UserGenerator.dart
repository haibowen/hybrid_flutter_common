/*
 * @author lsy
 * @date   2019-09-02
 **/
import 'dart:math';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:flutter_common/Annotations/anno/UserCenter.dart';
import 'package:source_gen/source_gen.dart';

import '../RouterCenterRestore.dart';

Map<String, String> map = {};

class UserGenerator extends GeneratorForAnnotation<UserCenter> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
          "Request class is not ok for ${element.displayName}");
    }
    StringBuffer buffer = new StringBuffer();
    for (var fieldData in (element as ClassElement).fields) {
      for (var annometadata in fieldData.metadata) {
        final metadata = annometadata.computeConstantValue();
        if (metadata.type.displayName == "User") {
          String key = metadata.getField("key").toStringValue();
          // String _${fieldData.name};
          if (fieldData.type.displayName == "String") {
            buffer.write("""
            Future<bool> save${fieldData.name}(String ${fieldData.name}) async{
              SharedPreferences sp=await SharedPreferences.getInstance();
              return sp.setString("${key}", ${fieldData.name});
            }
            Stream<String> get${fieldData.name}(){
              return Stream.fromFuture(SharedPreferences.getInstance())
                .flatMap((value) {
                  return Stream.value(value.getString("${key}"));
              });
            }
            """);
          } else if (fieldData.type.displayName == "int") {
            // int _${fieldData.name};
            buffer.write("""
            Future<bool> save${fieldData.name}(int ${fieldData.name}) async{
              SharedPreferences sp=await SharedPreferences.getInstance();
              return sp.setInt("${key}", ${fieldData.name});
            }
            Stream<int> get${fieldData.name}(){
              return Stream.fromFuture(SharedPreferences.getInstance())
                .flatMap((value) {
                  return Stream.value(value.getInt("${key}"));
              });
            }
            """);
          } else if (fieldData.type.displayName == "double") {
            //double _${fieldData.name};
            buffer.write("""
            Future<bool> save${fieldData.name}(double ${fieldData.name}) async{
              SharedPreferences sp=await SharedPreferences.getInstance();
              return sp.setDouble("${key}", ${fieldData.name});
            }
            Stream<double> get${fieldData.name}(){
              return Stream.fromFuture(SharedPreferences.getInstance())
                .flatMap((value) {
                  return Stream.value(value.getDouble("${key}"));
              });
            }
            """);
          } else if (fieldData.type.displayName == "bool") {
            //bool _${fieldData.name};
            buffer.write("""
            Future<bool> save${fieldData.name}(bool ${fieldData.name}) async{
              SharedPreferences sp=await SharedPreferences.getInstance();
              return sp.setBool("${key}", ${fieldData.name});
            }
            Stream<bool> get${fieldData.name}(){
              return Stream.fromFuture(SharedPreferences.getInstance())
                .flatMap((value) {
                  return Stream.value(value.getBool("${key}"));
              });
            }
            """);
          } else if (fieldData.type.displayName == "List<String>") {
            buffer.write("""
            Future<bool> save${fieldData.name}(List<String> ${fieldData.name}) async{
              SharedPreferences sp=await SharedPreferences.getInstance();
              return sp.setStringList("${key}", ${fieldData.name});
            }
            Stream<List<String>> get${fieldData.name}(){
              return Stream.fromFuture(SharedPreferences.getInstance())
                .flatMap((value) {
                  return Stream.value(value.getStringList("${key}"));
              });
            }
            """);
          }
        }
      }
    }


    return """
      import 'package:rxdart/rxdart.dart';
      import 'package:shared_preferences/shared_preferences.dart';
      
      class ${element.displayName}Impl{
      
        factory ${element.displayName}Impl() => _sharedInstance();

        static ${element.displayName}Impl _instance;

        ${element.displayName}Impl._() {
        }

        static ${element.displayName}Impl _sharedInstance() {
          if (_instance == null) {
            _instance = ${element.displayName}Impl._();
          }
          return _instance;
        }
        
        
        ${buffer.toString()}
        
         Future<bool> clearAll() async{
           SharedPreferences s=await SharedPreferences.getInstance();
            return s.clear();
         }
      }
    """;
  }
}
