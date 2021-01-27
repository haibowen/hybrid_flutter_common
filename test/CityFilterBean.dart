/*
 * @Author: zx 
 * @Date: 2021-01-05 14:20:23 
 * @Last Modified by: zx
 * @Last Modified time: 2021-01-08 11:09:02
 */
import 'package:gm_flutter/commonModel/bean/Area.dart';

class CityFilterBean {
  String message;
  Data data;
  int error;

  CityFilterBean({this.message, this.data, this.error});

  CityFilterBean.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['error'] = this.error;
    return data;
  }
}

class Data {
  Recommend recommend;
  List<Area> area;

  Data({this.recommend, this.area});

  Data.fromJson(Map<String, dynamic> json) {
    recommend = json['recommend'] != null
        ? new Recommend.fromJson(json['recommend'])
        : null;
    if (json['area'] != null) {
      area = new List<Area>();
      json['area'].forEach((v) {
        area.add(new Area.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.recommend != null) {
      data['recommend'] = this.recommend.toJson();
    }
    if (this.area != null) {
      data['area'] = this.area.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Recommend {
  List<Cities> located;
  List<Cities> hot;

  Recommend({this.located, this.hot});

  Recommend.fromJson(Map<String, dynamic> json) {
    if (json['located'] != null) {
      located = new List<Cities>();
      json['located'].forEach((v) {
        located.add(new Cities.fromJson(v));
      });
    }
    if (json['hot'] != null) {
      hot = new List<Cities>();
      json['hot'].forEach((v) {
        hot.add(new Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.located != null) {
      data['located'] = this.located.map((v) => v.toJson()).toList();
    }
    if (this.hot != null) {
      data['hot'] = this.hot.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Area {
  String id;
  String name;
  List<Cities> cities;

  Area({this.id, this.name, this.cities});

  Area.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['cities'] != null) {
      cities = new List<Cities>();
      json['cities'].forEach((v) {
        cities.add(new Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.cities != null) {
      data['cities'] = this.cities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
