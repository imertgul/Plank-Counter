import 'package:flutter/material.dart';
import './pages/homepage.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plank Counter',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
