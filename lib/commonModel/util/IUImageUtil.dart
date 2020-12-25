/*
 * @author lsy
 * @date   2019-12-04
 **/
import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class IUImageUtil {
  static Stream<ui.Image> getIUImage(String path, bool isNet) {
    ImageStream stream;
    if (isNet) {
      stream = NetworkImage(
        path,
      ).resolve(ImageConfiguration.empty);
    } else {
      stream = AssetImage(path, bundle: rootBundle)
          .resolve(ImageConfiguration.empty);
    }
    Completer<ui.Image> completer = Completer<ui.Image>();
    void listener(ImageInfo frame, bool synchronousCall) {
      final ui.Image image = frame.image as ui.Image;
      completer.complete(image);
      stream.removeListener(ImageStreamListener(listener));
    }

    stream.addListener(ImageStreamListener(listener));
    return Stream.fromFuture(completer.future);
  }
}
