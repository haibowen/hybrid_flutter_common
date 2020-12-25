import 'package:flutter_common/Annotations/Generator/DioGenerator.dart';
import 'package:flutter_common/Annotations/Generator/ServiceGenerator.dart';
import 'package:flutter_common/Annotations/Generator/UserGenerator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/src/builder/builder.dart';

import 'Generator/EntityGenerator.dart';
import 'Generator/RouterCenterGenerator.dart';
import 'Generator/RouterGenerator.dart';


Builder routerBuilder(BuilderOptions options) =>
    LibraryBuilder(RouterGenerator(), generatedExtension: ".rout.dart");

Builder routerCenterBuilder(BuilderOptions options) =>
    LibraryBuilder(RouterCenterGenerator(), generatedExtension: ".mark.dart");

Builder userBuilder(BuilderOptions options)=>
    LibraryBuilder(UserGenerator(),generatedExtension: ".user.dart");

Builder apiBuilder(BuilderOptions options)=>
    LibraryBuilder(ServiceGenerator(),generatedExtension: ".serv.dart");

Builder entityBuilder(BuilderOptions options) =>
    LibraryBuilder(EntityGenerator(), generatedExtension: ".enti.dart");

Builder dioBuilder(BuilderOptions options) =>
    LibraryBuilder(DioGenerator(), generatedExtension: ".dio.dart");
