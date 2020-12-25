/*
 * @author lsy
 * @date   2019-12-18
 **/
import 'package:url_launcher/url_launcher.dart';

class LaunchUtil {
  static void launchPhone(String phone) async {
    var url = "tel:${phone}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
