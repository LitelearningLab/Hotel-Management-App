import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Utils {
  static const platform = const MethodChannel('lite');

  static String convertTime(String timeString, {isTimeOnly = false}) {
    DateFormat inputFormat = DateFormat('HH:mm:ss');
    DateFormat outputFormat = DateFormat('hh:mm a');

    // DateTime dateTime = inputFormat.parse(timeString);
    if (!isTimeOnly) {
      return outputFormat.format(DateTime.parse(timeString));
    } else {
      return outputFormat.format(inputFormat.parse(timeString));
    }
  }

  static Future<String> getUUID() async {
    try {
      return await platform.invokeMethod('getUID');
    } on PlatformException catch (e) {
      print(e);
    }
    print("_uid");
    return "";
  }
}
