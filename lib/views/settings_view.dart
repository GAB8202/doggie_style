import 'package:flutter/material.dart';


class SettingView extends StatelessWidget {
  // Pass the title as a parameter if needed, or just hardcode it inside the widget
  final String title;

  SettingView({Key? key, this.title = "Doggie Style"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        centerTitle: true,
        title: Transform.scale(
          scale: 2,
          child: IconButton(
            icon: Image.asset('assets/images/DSLogoPaw_white.png'),
            onPressed: () {},
          ),
        ),
        backgroundColor: Color(0xc3e7fdff).withOpacity(.5),

      ),
      body: Container(
        child: Column(
          children: [
            Text("Settings"),
          ],
        ),
      ),

    );
  }
}