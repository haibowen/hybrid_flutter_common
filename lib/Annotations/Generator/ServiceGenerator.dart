/*
 * @author lsy
 * @date   2019-09-03
 **/
import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:flutter_common/Annotations/anno/ServiceCenter.dart';
import 'package:flutter_common/Annotations/restore/ServerRestore.dart';
import 'package:source_gen/source_gen.dart';
// import 'package:flutter/material.dart';

class ServiceGenerator extends GeneratorForAnnotation<ServiceCenter> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    print("element is $element");
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
          "Request class is not ok for ${element.displayName}");
    }
    StringBuffer improtBuffer = new StringBuffer();
    StringBuffer methodBuffer = StringBuffer("");
    StringBuffer outBuffer = StringBuffer();
    StringBuffer mapBuffer = new StringBuffer();
    List<String> outList = [];
    List<String> differentList = [];
    // MethodElement
    for (var methodElement in (element as ClassElement).methods) {
      for (var annometadata in methodElement.metadata) {
        final metadata = annometadata.computeConstantValue();
        if (metadata.type.getDisplayString(withNullability: false) == "Post" ||
            metadata.type.getDisplayString(withNullability: false) == "Get" ||
            metadata.type.getDisplayString(withNullability: false) == "Put" ||
            metadata.type.getDisplayString(withNullability: false) ==
                "Delete" ||
            metadata.type.getDisplayString(withNullability: false) ==
                "Upload") {
          if (!differentList.contains(methodElement.returnType
              .getDisplayString(withNullability: false))) {
            if (ServerRestore.getInstance().map.containsKey(methodElement
                .returnType
                .getDisplayString(withNullability: false))) {
              improtBuffer.write(ServerRestore.getInstance().map[methodElement
                  .returnType
                  .getDisplayString(withNullability: false)]);
            } else {
              var pathSegments = buildStep.inputId.pathSegments;
              StringBuffer path = new StringBuffer();
              for (int i = 0; i < pathSegments.length; i++) {
                if (i < pathSegments.length - 2 && pathSegments[i] != "lib") {
                  path.write("${pathSegments[i]}/");
                }
              }
              improtBuffer.write(
                  "import 'package:${buildStep.inputId.package}/${path.toString()}entity/${methodElement.returnType.getDisplayString(withNullability: false)}.dart\';\n");
            }
          }
          differentList.add(methodElement.returnType
              .getDisplayString(withNullability: false));
          String tempParams;
          int dataCount = 0;
          int uploadCount = 0;
          StringBuffer dataBuffer = StringBuffer();
          StringBuffer uploadBuffer = StringBuffer();
          for (int i = 0; i < methodElement.parameters.length; i++) {
            // ParameterElement
            var paramsMeta = methodElement.parameters[i];
            print("zx======param=====${paramsMeta}");
            if (paramsMeta.metadata.length == 0) {
              throw InvalidGenerationSourceError(
                  "Service params need Query or Upload .....");
            }
            // ElementAnnotation
            var parameter = paramsMeta.metadata[0];
            final queryAnno = parameter.computeConstantValue();
            // 这里手动处理一下，去掉*，目前还不知道为啥会自带*
            var paramsMetaStr = "${paramsMeta}".contains("*")
                ? "${paramsMeta}".replaceFirst("*", "")
                : "${paramsMeta}";
            print("zx======paramStr=====${paramsMetaStr}");
            if (tempParams == null) {
              tempParams = "${paramsMetaStr}";
            } else {
              tempParams = "${tempParams},${paramsMetaStr}";
            }
            String fromDataValue = paramsMeta.name;
            String fromDataKey;

            if (queryAnno.type.getDisplayString(withNullability: false) ==
                "Query") {
              fromDataKey = queryAnno.getField("params").toStringValue();
              if (dataCount == 0) {
                dataBuffer.write(",data:{\'${fromDataKey}\':${fromDataValue},");
              } else {
                dataBuffer.write("\'${fromDataKey}\':${fromDataValue},");
              }
              dataCount++;
            } else if (queryAnno.type
                    .getDisplayString(withNullability: false) ==
                "UploadFilePath") {
              fromDataKey = queryAnno.getField("params").toStringValue();
              uploadBuffer.write(",\'${fromDataKey}\',${fromDataValue}");
              uploadCount++;
            }
            if (fromDataKey == null) {
              throw InvalidGenerationSourceError(
                  "Service params need Query or Upload .....");
            }
          }
          mapBuffer.write("""
          return Stream.fromFuture(${metadata.type.getDisplayString(withNullability: false).toLowerCase()}(_dio,\'${metadata.getField("sufUrl").toStringValue()}\'
          """);
          if (uploadBuffer.toString().isNotEmpty) {
            mapBuffer.write(uploadBuffer.toString());
          }
          if (dataBuffer.toString().isNotEmpty) {
            dataBuffer.write("}");
            mapBuffer.write(dataBuffer.toString());
          }
          //else{
          //                throw HttpException("RESPONCE error :\${value}");
          //              }

//                Map map = json.decode(value.toString());
//                return ${methodElement.returnType.getDisplayString(withNullability: false)}.fromJson(map);
          mapBuffer.write("))");
          if (!outList.contains(methodElement.returnType
              .getDisplayString(withNullability: false))) {
            outList.add(methodElement.returnType
                .getDisplayString(withNullability: false));
            outBuffer.write("""
            ${methodElement.returnType.getDisplayString(withNullability: false)} parse${methodElement.returnType.getDisplayString(withNullability: false)}(String value){
              return ${methodElement.returnType.getDisplayString(withNullability: false)}.fromJson(json.decode(value));
            }\n
          """);
          }

          mapBuffer.write("""
            .flatMap((value){
              if(value!=null&&(value.statusCode>=200&&value.statusCode<300)){
                  return Stream.fromFuture(compute(parse${methodElement.returnType.getDisplayString(withNullability: false)}, value.toString()));
              }else {
                throw Exception("--未知网络错误--");
              }
            });
          """);
//          mapBuffer.write("""
//            .map((value){
//              if(value!=null&&value.statusCode==200){
//                Map map = json.decode(value.toString());
//                return ${methodElement.returnType.getDisplayString(withNullability: false)}.fromJson(map);
//              }
//            });
//          """);

          methodBuffer.write("""               
                  Stream<${methodElement.returnType.getDisplayString(withNullability: false)}> ${methodElement.name}(Dio _dio,${tempParams == null ? "" : tempParams}){
                    ${mapBuffer.toString()}
                  }
                  """);
          mapBuffer.clear();
        }
      }
    }
    //static Dio _dio;
    //import 'package:example_flutter/commonModel/net/DioUtil.dart';\n
    return """
    ${ServerRestore.getInstance().dioDir == null ? "" : ServerRestore.getInstance().dioDir}
    import 'dart:convert';\n
    import 'dart:io';\n
    import 'package:rxdart/rxdart.dart';\n
    import 'package:dio/dio.dart';\n
    import 'package:flutter/foundation.dart';\n
    ${improtBuffer.toString()}
    class ${element.displayName}Impl{
      
        bool inProduction = false;
        StringBuffer traceBuffer = new StringBuffer();
        
        void setIsRelease(bool isRelease){
          this.inProduction=isRelease;
        }
        
        String getTraceBuffer(){
          return traceBuffer.toString();
        }
        
        void clearTrace(){
            traceBuffer.clear();
        }
        
        static JsonEncoder encoder = JsonEncoder.withIndent('  ');
        
        static ${element.displayName}Impl _instance;

        ${element.displayName}Impl._() {
        }

        static ${element.displayName}Impl getInstance() {
          if (_instance == null) {
            _instance = ${element.displayName}Impl._();
          }
          return _instance;
        }
      
      ${methodBuffer.toString()}
      
      
      
      
      
      
      
      
      ///==================base method==================

      Future<Response> get(Dio _dio,url, {data, options, cancelToken}) async {
        Response response;
        try {
          int startTime = DateTime.now().millisecondsSinceEpoch;
          response = await _dio.get(url,
            queryParameters: data, options: options, cancelToken: cancelToken);
          _printHttpLog(response, DateTime.now().millisecondsSinceEpoch - startTime);
        } on DioError catch (e) {
          print('get error---------\$e  \${formatError(e)}');
          throw e;
        }
        return response;
      }

      Future<Response> post(Dio _dio,url, {data, options, cancelToken}) async {
        Response response;
        try {
          int startTime = DateTime.now().millisecondsSinceEpoch;
          response = await _dio.post(url,
              data: data,
              options: options,
              cancelToken: cancelToken);
          _printHttpLog(response, DateTime.now().millisecondsSinceEpoch - startTime);
        } on DioError catch (e) {
          print('get error---------\$e  \${formatError(e)}');
          throw e;
        }
        return response;
      }
      
      Future<Response> put(Dio _dio,url, {data, options, cancelToken}) async {
        Response response;
        try {
          int startTime = DateTime.now().millisecondsSinceEpoch;
          response = await _dio.put(url,
              data: FormData.fromMap(data), options: options, cancelToken: cancelToken);
          _printHttpLog(response, DateTime.now().millisecondsSinceEpoch - startTime);
        } on DioError catch (e) {
          print('get error---------\$e  \${formatError(e)}');
          throw e;
        }
        return response;
      }
      
      Future<Response> delete(Dio _dio,url, {data, options, cancelToken}) async {
        Response response;
        try {
          int startTime = DateTime.now().millisecondsSinceEpoch;
          response = await _dio.delete(url,
              data: FormData.fromMap(data), options: options, cancelToken: cancelToken);
          _printHttpLog(response, DateTime.now().millisecondsSinceEpoch - startTime);
        } on DioError catch (e) {
          print('get error---------\$e  \${formatError(e)}');
          throw e;
        }
        return response;
      }
      
      Future<Response> upload(Dio _dio,url,String key, String path, {Map<String, dynamic> data, options, cancelToken}) async {
        Response response;
        print("UPLOAD===> URL:\$url  {\$key : \$path }   data:\$data");
        MultipartFile file = await MultipartFile.fromFile(path,
          filename: path.substring(path.lastIndexOf("/") + 1, path.length));
        if(data==null){
          data=new Map<String, dynamic>();
        }
        data.putIfAbsent(key, () => file);
        try {
          int startTime = DateTime.now().millisecondsSinceEpoch;
          response = await _dio.post(url,
              data: FormData.fromMap(data), options: options, cancelToken: cancelToken);
          _printHttpLog(response, DateTime.now().millisecondsSinceEpoch - startTime);
        } on DioError catch (e) {
          print('get error---------\$e  \${formatError(e)}');
          throw e;
        }
        return response;
      }
            
      void _printHttpLog(Response response, int useTime) {
        if(!inProduction){
          try {
            if(response!=null){
              traceBuffer.write("gmTraceStart-> useTime:\${useTime} method:\${response.request.method} uri:\${response.request.uri} heads:\${response.request.headers.toString()} params:\${response.request.queryParameters} datas:\${response.request.queryParameters.toString()} respondData:\${response.toString()} <-gmTraceEnd @@");
            }
            printRespond(response);
          } catch (ex) {
            print("Http Log" + " error......");
          }
        }
      }

      static void printRespond(Response response) {
        Map httpLogMap = Map();
        httpLogMap.putIfAbsent("requestMethod", () => "\${response.request.method}");
        httpLogMap.putIfAbsent("requestUrl", () => "\${response.request.uri}");
        httpLogMap.putIfAbsent("requestHeaders", () => response.request.headers);
        httpLogMap.putIfAbsent(
            "requestQueryParameters", () => response.request.queryParameters);
        if(response.request.data is FormData){
          httpLogMap.putIfAbsent("requestDataFields",() => ((response.request.data as FormData).fields.toString()));
        }
        httpLogMap.putIfAbsent("respondData", () => json.decode (response.toString()));
        printJson(httpLogMap);
      }
      
      static void printJson(Object object) {
        try {
          var encoderString = encoder.convert(object);
          debugPrint(encoderString);
        } catch (e) {
          print(e);
        }
      }
      
      String formatError(DioError e) {
        String reason = "";
        if (e.type == DioErrorType.connectTimeout) {
          reason = "连接超时 \${e.message}";
        } else if (e.type == DioErrorType.sendTimeout) {
          reason = "请求超时 \${e.message}";
        } else if (e.type == DioErrorType.receiveTimeout) {
          reason = "响应超时 \${e.message}";
        } else if (e.type == DioErrorType.response) {
          reason = "出现异常 \${e.message}";
        } else if (e.type == DioErrorType.cancel) {
          reason = "请求取消 \${e.message}";
        } else {
          reason = "未知错误 \${e.message}";
        }
        return reason;
      }
      
    }
    ${outBuffer.toString()}
    """;
  }
}
