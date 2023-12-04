import 'package:flutter/material.dart';
import 'package:navigation/views/home_view.dart';

class MessageView extends StatelessWidget {
  final String title;

  MessageView({Key? key, this.title = "Doggie Style"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        centerTitle: true,
        title: Transform.scale(
          scale: 2,
          child: IconButton(
            icon: Image.asset('assets/images/DSLogoPaw_white.png'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeView()),
              );
            },
          ),
        ),
        backgroundColor:  Color(0x64c3e7fd).withOpacity(1),

      ),
      body: Container(
        child: Column(
          children: [
            Text("Messages"),
          ],
        ),
      ),

    );
  }
}