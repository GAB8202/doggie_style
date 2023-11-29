import 'package:flutter/material.dart';
import 'package:navigation/views/home_view.dart';
import 'start_view.dart';


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
            onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeView()),
            );},
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showLogoutDialog(context),
        child: Text('Log out'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => StartScreen()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}