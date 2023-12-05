import 'package:flutter/material.dart';
import '../views/home_view.dart';
import '../view_models/profile_view_model.dart';

class MessageView extends StatelessWidget {
  final String title;
  final ProfileViewModel viewModel;

  MessageView({Key? key, this.title = "Doggie Style", required this.viewModel}) : super(key: key);

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
                MaterialPageRoute(builder: (context) => HomeView(viewModel: viewModel)),
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