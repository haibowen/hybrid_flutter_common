/*
 * @author lsy
 * @date   2019-10-18
 **/

import 'package:flutter/material.dart';

class DialogRouter extends PageRouteBuilder {
  final Widget page;

  DialogRouter(this.page)
      : super(
            opaque: false,
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return child;
            });
}
