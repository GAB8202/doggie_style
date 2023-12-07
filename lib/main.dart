import 'package:flutter/material.dart';
import 'package:navigation/views/home_view.dart';
import 'views/start_view.dart';
import 'view_models/profile_view_model.dart';
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