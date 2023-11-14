import 'package:flutter/material.dart';
import 'profile_view.dart';

class HomeView extends StatelessWidget {
  // Pass the title as a parameter if needed, or just hardcode it inside the widget
  final String title;

  HomeView({Key? key, this.title = "Doggie Style"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.person, color: Colors.white.withOpacity(1)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileView()),
            );
          },
        ),
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
      body: Container(),
    );
  }
}