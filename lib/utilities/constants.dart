import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

Map<String, int> categories = {
  'Pazartesi': 88,
  'Salı': 88,
  'Çarşamba': 88,
  'Perşembe': 88,
  'Cuma': 88,
  'Cumartesi': 88,
  'Pazar': 88,
};

Map<String, int> history = {};

List gunler = [
  'Pazartesi',
  'Salı',
  'Çarşamba',
  'Perşembe',
  'Cuma',
  'Cumartesi',
  'Pazar',
];

class Renkler {
  static const Color primary = Color(0xff37474f);
  static const Color pLight = Color(0xff62727b);
  static const Color pDark = Color(0xff102027);
  static const Color textOnP = Colors.white;
  static const Color secondary = Color(0xff79538E);
  static const Color sLight = Color(0xffAF91BB);
  static const Color sDark = Color(0xff533266);
  static const Color textOnS = Colors.white;
  // static const Color secondary = Color(0xff00838f);
  // static const Color sLight = Color(0xff4fb3bf);
  // static const Color sDark = Color(0xff005662);
}

String todayToString() {
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  String formatted = formatter.format(now);
  return formatted;
}

Future<int> read(String day) async {
  final prefs = await SharedPreferences.getInstance();
  final key = day;
  final value = prefs.getInt(key) ?? 0;
  print('read: $value  --- $day');
  return value;
}

save(int record) async {
  final prefs = await SharedPreferences.getInstance();
  final key = todayToString();
  final value = record;
  prefs.setInt(key, value);
  print('saved $value');
}

saveSample() async {
  final prefs = await SharedPreferences.getInstance();
  String key = todayToString();
  for (var i = 0; i < 25; i++) {
    final value = i;    
    prefs.setInt(key, value);
    print('saved $value');
    key = dateToString(DateTime.now().subtract(new Duration(days: i)));
  }
}

String dateToString(DateTime date) {
  var formatter = new DateFormat('yyyy-MM-dd');
  String formatted = formatter.format(date);
  return formatted;
}

String getWeekday(DateTime date) {
  String formatted = gunler[date.weekday - 1];
  return formatted;
}
