// lib/main.dart

import 'package:flutter/material.dart';
import 'views/doggie_view.dart';
import 'view_models/doggie_view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DoggieViewModel viewModel = DoggieViewModel(); // ViewModel instance

    return MaterialApp(
      title: 'Flutter MVVM Example',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Oswald',
      ),
      home: DoggieView(viewModel: viewModel),
    );
  }
}