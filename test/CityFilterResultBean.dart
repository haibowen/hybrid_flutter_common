/*
 * @Author: zx 
 * @Date: 2021-01-05 14:58:48 
 * @Last Modified by: zx
 * @Last Modified time: 2021-01-05 15:02:48
 */
import 'package:gm_flutter/commonModel/bean/Area.dart';

class CityFilterResultBean {
  String message;
  List<Cities> data;
  int error;

  CityFilterResultBean({this.message, this.data, this.error});

  CityFilterResultBean.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Cities>();
      json['data'].forEach((v) {
        data.add(new Cities.fromJson(v));
      });
    }
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['error'] = this.error;
    return data;
  }
}
