/*
 * @author lsy
 * @date   2019-12-24
 **/

import 'package:flutter/material.dart';
import 'package:flutter_common/commonModel/anim/Anim.dart';

class JumpUtil {
  static Future jumpToPageALP(BuildContext context, Widget widget) {
    return Navigator.of(context).push(CustomRoute(widget, routeWay: RouteWay.ALP));
  }

  static Future jumpToPageReplaceALP(BuildContext context, Widget widget) {
    return Navigator.of(context).pushReplacement(CustomRoute(widget, routeWay: RouteWay.ALP));
  }

  static Future jumpToPageRight(BuildContext context, Widget widget) {
    return Navigator.of(context).push(CustomRoute(widget, routeWay: RouteWay.TRAN_RIGHT_TO_LEFT));
  }

  static Future jumpToPageReplaceRight(BuildContext context, Widget widget) {
    return Navigator.of(context).pushReplacement(CustomRoute(widget, routeWay: RouteWay.TRAN_RIGHT_TO_LEFT));
  }

  static Future jumpToPageBottom(BuildContext context, Widget widget) {
    return Navigator.of(context).push(CustomRoute(widget, routeWay: RouteWay.TRAN_BOTTOM_TO_TOP));
  }

  static Future jumpToPageReplaceBottom(BuildContext context, Widget widget) {
    return Navigator.of(context).pushReplacement(CustomRoute(widget, routeWay: RouteWay.TRAN_BOTTOM_TO_TOP));
  }

  static Future jumpToPageScare(BuildContext context, Widget widget) {
    return Navigator.of(context).push(CustomRoute(widget, routeWay: RouteWay.SCARE));
  }

  static Future jumpToPageReplaceScare(BuildContext context, Widget widget) {
    return Navigator.of(context).pushReplacement(CustomRoute(widget, routeWay: RouteWay.SCARE));
  }
}
