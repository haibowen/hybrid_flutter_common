/*
 * @Author: zx 
 * @Date: 2021-01-05 14:58:48 
 * @Last Modified by: zx
 * @Last Modified time: 2021-01-05 15:02:48
 */
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

class Cities {
  String cityName;
  String id;
  String name;
  int cityTagId;
  String highlightedName;
  bool isLocatedCity;

  Cities(
      {this.cityName,
      this.id,
      this.name,
      this.cityTagId,
      this.highlightedName,
      this.isLocatedCity});

  Cities.fromJson(Map<String, dynamic> json) {
    highlightedName = json['highlighted_name'];
    cityName = json['city_name'];
    id = json['id'] == null ? "" : "${json['id']}";
    name = json['name'];
    cityTagId = json['city_tag_id'];
    isLocatedCity =
        json['is_located_city'] == null ? false : json['is_located_city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city_name'] = this.cityName;
    data['highlighted_name'] = this.highlightedName;
    data['id'] = this.id;
    data['name'] = this.name;
    data['city_tag_id'] = this.cityTagId;
    data['is_located_city'] = this.isLocatedCity;
    return data;
  }
}
