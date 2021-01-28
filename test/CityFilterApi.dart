/*
 * @Author: zx 
 * @Date: 2021-01-05 14:10:23 
 * @Last Modified by: zx
 * @Last Modified time: 2021-01-06 11:08:12
 */
import 'package:flutter_common/Annotations/anno/Get.dart';
import 'package:flutter_common/Annotations/anno/Query.dart';
import 'package:flutter_common/Annotations/anno/ServiceCenter.dart';
import 'CityFilterBean.dart';
import 'CityFilterResultBean.dart';
// import 'package:fl';

@ServiceCenter()
abstract class CityFilterApi {
  @Get("api/filter/service_home_city_v2")
  CityFilterBean getAllCities();

  @Get("api/city/home_search")
  CityFilterResultBean getFilterCities(
      @Query("keyword") String keyword, int num, bool isShow);
}
