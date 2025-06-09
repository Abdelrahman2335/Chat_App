import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDateTime {
  static dateFormat(String time) {
    String formatter = "";
    try {
      var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    formatter = DateFormat("yyy-MM-dd").format(dt).toString();
    return formatter;
  } catch (e) {
      return const CircularProgressIndicator();
    }
  }

  static String timeByHour(String time) {
    String dateNow = "";
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    dateNow = DateFormat("jm").format(date).toString();
    return dateNow;
  }
}
