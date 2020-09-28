import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coolors_palette/coolors_palette.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// final myColors = CoolorsPalette("https://coolors.co/006466-0b525b-1b3a4b-1e1f3b-1b1b2a-191921-171618-e2dee4");
final myColors = CoolorsPalette(
    "https://coolors.co/006466-0b525b-1b3a4b-192832-181f25-181b1f-171618-e2dee4");

class Renkler {
  static Color greenL = myColors.palette[0];
  static Color green = myColors.palette[1];
  static Color greenD = myColors.palette[2];
  static Color pinkD = myColors.palette[3];
  static Color pink = myColors.palette[4];
  static Color pinkL = myColors.palette[5];
  static Color dark = myColors.palette[7];
  static Color background = myColors.palette[6];
  static Color beyaz = Colors.white;
}

TextStyle myStyle12 = GoogleFonts.ubuntuCondensed(
    textStyle: TextStyle(fontSize: 12.0, color: Renkler.beyaz));
TextStyle myStyle16 = GoogleFonts.ubuntuCondensed(
    textStyle: TextStyle(fontSize: 15.0, color: Renkler.beyaz));

TextStyle myStyle16bold = GoogleFonts.ubuntuCondensed(
    textStyle: TextStyle(
        fontSize: 15.0, color: Renkler.beyaz, fontWeight: FontWeight.bold));

TextStyle myStyle18 = GoogleFonts.ubuntuCondensed(
    textStyle: TextStyle(fontSize: 18.0, color: Renkler.beyaz));

TextStyle myStyle18bold = GoogleFonts.ubuntuCondensed(
    textStyle: TextStyle(
        fontSize: 18.0, color: Renkler.beyaz, fontWeight: FontWeight.bold));
TextStyle myStyle40bold = GoogleFonts.ubuntuCondensed(
    textStyle: TextStyle(
        fontSize: 40.0, color: Renkler.beyaz, fontWeight: FontWeight.bold));
TextStyle myStyle16D = GoogleFonts.ubuntuCondensed(
    textStyle: TextStyle(fontSize: 15.0, color: Renkler.dark));

TextStyle myStyle16boldD = GoogleFonts.ubuntuCondensed(
    textStyle: TextStyle(
        fontSize: 15.0, color: Renkler.dark, fontWeight: FontWeight.bold));

TextStyle myStyle18D = GoogleFonts.ubuntuCondensed(
    textStyle: TextStyle(fontSize: 18.0, color: Renkler.dark));

TextStyle myStyle18boldD = GoogleFonts.ubuntuCondensed(
    textStyle: TextStyle(
        fontSize: 18.0, color: Renkler.dark, fontWeight: FontWeight.bold));

class RenklerYedek {
  static const Color primary = Color(0xff37474f);
  static const Color pLight = Color(0xff62727b);
  static const Color pDark = Color(0xff102027);
  static const Color dark = Color(0xff102027);
  static const Color textOnP = Colors.white;
  static const Color secondary = Color(0xff79538E);
  static const Color sLight = Color(0xffAF91BB);
  static const Color sDark = Color(0xff533266);
  static const Color textOnS = Colors.white;
  // static const Color secondary = Color(0xff00838f);
  // static const Color sLight = Color(0xff4fb3bf);
  // static const Color sDark = Color(0xff005662);
}

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
