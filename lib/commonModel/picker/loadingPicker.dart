/*
 * @author lsy
 * @date   2019-10-18
 **/

import 'package:flutter/material.dart';

import 'base/DialogRouter.dart';

Future popLoadingDialog(
    BuildContext context, bool canceledOnTouchOutside, String text) {
  return Navigator.push(
      context, DialogRouter(LoadingDialog(canceledOnTouchOutside, text)));
}

void dismissLoadingDialog(BuildContext context) {
  Navigator.pop(context);
}

class LoadingDialog extends Dialog {
  LoadingDialog(this.canceledOnTouchOutside, this.text) : super();

  ///点击背景是否能够退出
  final bool canceledOnTouchOutside;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Material(

          ///背景透明
          color: Colors.black54,

          ///保证控件居中效果
          child: Stack(
            children: <Widget>[
              GestureDetector(
                ///点击事件
                onTap: () {
                  if (canceledOnTouchOutside) {
                    Navigator.pop(context);
                  }
                },
              ),
              _dialog()
            ],
          )),
    );
  }

  Widget _dialog() {
    return new Center(
      ///弹框大小
      child: new Container(
        width: 120.0,
        height: 120.0,
        child: new Container(
          ///弹框背景和圆角
          decoration: ShapeDecoration(
            color: Color(0xffffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new CircularProgressIndicator(),
              new Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                ),
                child: new Text(
                  text,
                  style: new TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
