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
          icon: Icon(Icons.person, color: const Color(0xffffffff).withOpacity(1)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileView()),
            );
          },
        ),

        /*title: Text(
          viewModel.doggieText,
          style: TextStyle(fontFamily: 'Indie Flower', fontSize: 36, fontWeight: FontWeight.bold),
        ),*/
        centerTitle: true,
        //an idea from maggie, can we switch this so that the title is the logo image?
        title: Transform.scale(
          scale: 2,
          child: IconButton(
            icon: Image.asset('assets/images/DSLogoPaw_white.png'),
            onPressed: () {},
          ),
        ),



        //backgroundColor: Colors.blueGrey,

        backgroundColor: const Color(0xc3e7fdff).withOpacity(.5),
      ),
      body: Container(),
    );
  }
}