import 'package:flutter/material.dart';
import '../views/home_view.dart';
import 'start_view.dart';
import '../view_models/profile_view_model.dart';


class SettingView extends StatelessWidget {
  // Pass the title as a parameter if needed, or just hardcode it inside the widget
  final String title;
  final ProfileViewModel viewModel;

  const SettingView({Key? key, this.title = "Doggie Style", required this.viewModel}) : super(key: key);

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
                MaterialPageRoute(builder: (context) => HomeView(viewModel: viewModel,)),
              );},
          ),
        ),
        backgroundColor:  const Color(0x64c3e7fd).withOpacity(1),

      ),
      body: const Column(
        children: [
          //Text("Settings"),
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top:25.0),
            child: Text("Location Preference",style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),
                textAlign: TextAlign.left),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top:0.0),
            child: DistanceSlider(),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top:25.0),
            child: Text("Notification Preference",style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),
                textAlign: TextAlign.left),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top:25.0),
            child: Text("Location",style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),
                textAlign: TextAlign.left),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButtons(context),
    );
  }

  Widget _buildFloatingActionButtons(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Positioned(
          left: 48.0,
          bottom: 16.0,
          child: Transform.scale(
            scale: 1.2,
            child: FloatingActionButton(
              heroTag: 'deleteAccountButton',
              onPressed: () => _showDeleteAccountDialog(context),
              backgroundColor: const Color(0x64c3e7fd).withOpacity(1),
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text('Delete Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 16.0,
          bottom: 16.0,
          child: Transform.scale(
            scale: 1.2,
            child: FloatingActionButton(
              heroTag: 'logoutButton',
              onPressed: () => _showLogoutDialog(context),
              backgroundColor: const Color(0x64c3e7fd).withOpacity(1),
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text('Log out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Yes'),
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

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                await viewModel.deleteProfile();
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


class DistanceSlider extends StatefulWidget {
  const DistanceSlider({super.key});

  @override
  State<DistanceSlider> createState() => _DistanceSliderState();
}

class _DistanceSliderState extends State<DistanceSlider> {
  double _currentSliderValue = 10;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentSliderValue,
      max: 100,
      divisions: 10,
      activeColor: Colors.lightBlue[500],
      inactiveColor: Colors.lightBlue[100],
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },

    );
  }
}