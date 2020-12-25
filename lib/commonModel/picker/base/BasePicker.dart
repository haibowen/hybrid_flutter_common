/*
 * @author lsy
 * @date   2020/8/6
 **/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/commonModel/live/LiveData.dart';
import 'package:flutter_common/commonModel/picker/base/IPicker.dart';

import 'BasePickerNotify.dart';
import 'DialogRouter.dart';
import 'IBottomPicker.dart';
import 'ICenterPicker.dart';

class BasePicker extends StatefulWidget {
  IPicker picker;
  bool cancelOutSide = true;
  double backMaxAlp = 255 / 2 - 10;
  bool interruptBackEvent = false;
  int during = 260;

  setBackMaxAlp(double max) {
    this.backMaxAlp = max;
  }

  setDuring(int during) {
    this.during = during;
  }

  setPicker(IPicker picker) {
    this.picker = picker;
  }

  setCancelOutside(bool cancel) {
    this.cancelOutSide = cancel;
  }

  setInterruptBackEvent(bool set) {
    interruptBackEvent = set;
  }

  Future show(BuildContext content) {
    return Navigator.push(content, DialogRouter(this));
  }

  @override
  State<StatefulWidget> createState() => BaseCenterPickerState();
}

class BaseCenterPickerState extends State<BasePicker>
    with SingleTickerProviderStateMixin {
  Animation<Offset> animation;
  AnimationController controller;
  LiveData<double> backLive = LiveData();
  bool isDismissing = false;
  BasePickerNotify _baseCenterNotify = new BasePickerNotify();

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
        duration: Duration(milliseconds: widget.during), vsync: this);
    controller
      ..addStatusListener((state) {
        if (state == AnimationStatus.dismissed && controller.value == 0) {
          if (_baseCenterNotify.iPicker != null) {
            widget.picker.dispose();
            widget.picker = _baseCenterNotify.iPicker;
            isDismissing = false;
            _baseCenterNotify.iPicker.initState(_baseCenterNotify, context);
            setState(() {});
            controller.forward();
          } else {
            Navigator.pop(context);
          }
        }
      });
    animation =
        new Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(controller)
          ..addListener(() {
            backAnim(1 - animation.value.dy.abs());
          });
    controller.forward();
    if (!_baseCenterNotify.hasListeners) {
      _baseCenterNotify.addListener(() {
        if (isDismissing) {
          return;
        }
        isDismissing = true;
        controller.reverse();
      });
    }
    widget.picker.initState(_baseCenterNotify, context);
  }

  void backAnim(double dy) {
    backLive.notifyView(dy);
  }

  @override
  void dispose() {
    controller.dispose();
    backLive.dispost();
    widget.picker.dispose();
    _baseCenterNotify.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Material(
          color: Colors.transparent,
          child: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (widget.cancelOutSide) {
                      _baseCenterNotify.iPicker = null;
                      controller.reverse();
                    }
                  },
                  child: StreamBuilder<double>(
                    stream: backLive.stream,
                    initialData: 0,
                    builder: (c, data) {
                      int alp = (data.data * widget.backMaxAlp).floor();
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: Color.fromARGB(alp, 0, 0, 0),
                      );
                    },
                  ),
                ),
                widget.picker is IBottomPicker
                    ? Positioned(
                        bottom: 0,
                        child: SlideTransition(
                          position: animation,
                          child:
                              (widget.picker as IBottomPicker).build(context),
                        ))
                    : Center(
                        child: StreamBuilder<double>(
                        stream: backLive.stream,
                        initialData: 0,
                        builder: (c, data) {
                          int alp = (data.data * 255).ceil();
                          return (widget.picker as ICenterPicker)
                              .build(context, alp);
                        },
                      ))
              ],
            ),
          )),
      onWillPop: () {
        if (!widget.interruptBackEvent) {
          _baseCenterNotify.iPicker = null;
          if (isDismissing) {
            return;
          }
          isDismissing = true;
          controller.reverse();
        }
      },
    );
  }
}
