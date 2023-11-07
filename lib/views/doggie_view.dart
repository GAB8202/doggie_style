// lib/views/doggie_view.dart

import 'package:flutter/material.dart';
import 'profile_view.dart';
import '../view_models/doggie_view_model.dart';

class DoggieView extends StatelessWidget {
  final DoggieViewModel viewModel;

  DoggieView({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileView()),
            );
          },
        ),
        title: Text(
          viewModel.doggieText,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(),
    );
  }
}