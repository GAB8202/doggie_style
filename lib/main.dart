import 'package:flutter/material.dart';
import 'views/start_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doggie Style',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Oswald',
      ),
      home: StartScreen(),
    );
  }
}