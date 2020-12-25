/*
 * @author lsy
 * @date   2019-12-18
 **/
import 'package:logger/logger.dart';

class LogUtil {
  static var logger = new Logger( printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: true // Should each log print contain a timestamp
  ),);

  static void e(String xxx) {
    logger.e(xxx);
  }

  static void w(String xxx) {
    logger.w(xxx);
  }

  static void i(String xxx) {
    logger.i(xxx);
  }

  static void d(String xxx) {
    logger.d(xxx);
  }
}
