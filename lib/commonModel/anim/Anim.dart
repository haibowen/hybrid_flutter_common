/*
 * @author lsy
 * @date   2019-10-14
 **/

import 'dart:io';

import 'package:flutter/material.dart';

enum RouteWay {
  SCARE,
  TRAN_RIGHT_TO_LEFT,
  TRAN_BOTTOM_TO_TOP,
  ALP,
}

class CustomRoute extends PageRouteBuilder {
  final Widget widget;

  RouteWay routeWay;

  CustomRoute(this.widget, {RouteWay routeWay = RouteWay.TRAN_RIGHT_TO_LEFT})
      : super(
            // 设置过度时间
            transitionDuration: Duration(milliseconds: 230),
            // 构造器
            pageBuilder: (
              // 上下文和动画
              BuildContext context,
              Animation<double> animaton1,
              Animation<double> animaton2,
            ) {
              return widget;
            },
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animaton1,
              Animation<double> animaton2,
              Widget child,
            ) {
              // 渐变效果
              if (routeWay.index == 3) {
                return FadeTransition(
                  // 从0开始到1
                  opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    // 传入设置的动画
                    parent: animaton1,
                    // 设置效果，快进漫出   这里有很多内置的效果
                    curve: Curves.fastOutSlowIn,
                  )),
                  child: child,
                );
              } else if (routeWay.index == 2) {
                return SlideTransition(
                  position: Tween<Offset>(
                          begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                      .animate(CurvedAnimation(
                          parent: animaton1, curve: Curves.fastOutSlowIn)),
                  child: child,
                );
              } else if (routeWay.index == 1) {
                return SlideTransition(
                  position: Tween<Offset>(
                          begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                      .animate(CurvedAnimation(
                          parent: animaton1, curve: Curves.fastOutSlowIn)),
                  child: child,
                );
//                } else {
//                  return SlideTransition(
//                    position: Tween<Offset>(
//                        begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
//                        .animate(CurvedAnimation(
//                        parent: animaton1, curve: Curves.fastOutSlowIn)),
//                    child: child,
//                  );
//                }
              } else {
                return ScaleTransition(
                  scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                      parent: animaton1, curve: Curves.fastOutSlowIn)),
                  child: child,
                );
              }
//         旋转加缩放动画效果
//         return RotationTransition(
//           turns: Tween(begin: 0.0,end: 1.0)
//           .animate(CurvedAnimation(
//             parent: animaton1,
//             curve: Curves.fastOutSlowIn,
//           )),
//           child: ScaleTransition(
//             scale: Tween(begin: 0.0,end: 1.0)
//             .animate(CurvedAnimation(
//               parent: animaton1,
//               curve: Curves.fastOutSlowIn
//             )),
//             child: child,
//           ),
//         );
            });
}
