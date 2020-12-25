// Ensure that the build script itself is not opted in to null safety,
// instead of taking the language version from the current package.
//
// @dart=2.9
//
// ignore_for_file: directives_ordering

import 'package:build_runner_core/build_runner_core.dart' as _i1;
import 'package:flutter_common/Annotations/ServiceGenerator.dart' as _i2;
import 'package:source_gen/builder.dart' as _i3;
import 'dart:isolate' as _i4;
import 'package:build_runner/build_runner.dart' as _i5;
import 'dart:io' as _i6;

final _builders = <_i1.BuilderApplication>[
  _i1.apply(r'flutter_common:Router', [_i2.routerBuilder], _i1.toRoot(),
      hideOutput: true),
  _i1.apply(r'flutter_common:server_entity', [_i2.entityBuilder], _i1.toRoot(),
      hideOutput: true),
  _i1.apply(r'flutter_common:apiGenerator', [_i2.apiBuilder], _i1.toRoot(),
      hideOutput: false,
      appliesBuilders: const [r'source_gen:combining_builder']),
  _i1.apply(
      r'flutter_common:routerCenter', [_i2.routerCenterBuilder], _i1.toRoot(),
      hideOutput: false),
  _i1.apply(r'flutter_common:user', [_i2.userBuilder], _i1.toRoot(),
      hideOutput: false),
  _i1.apply(r'source_gen:combining_builder', [_i3.combiningBuilder],
      _i1.toNoneByDefault(),
      hideOutput: false, appliesBuilders: const [r'source_gen:part_cleanup']),
  _i1.applyPostProcess(r'source_gen:part_cleanup', _i3.partCleanup)
];
void main(List<String> args, [_i4.SendPort sendPort]) async {
  var result = await _i5.run(args, _builders);
  sendPort?.send(result);
  _i6.exitCode = result;
}
