import 'package:flutter/material.dart';
import 'profile_view.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool showLogin = false;
  bool showSignUp = false;
  bool isAppBarBlue = false; // Added a flag to track the blue color

  // Text editing controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Add the leading back arrow button
        leading: showLogin || showSignUp
            ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => setState(() {
            showLogin = false;
            showSignUp = false;
            isAppBarBlue = false; // Set transparency when going back
          }),
        )
            : null,
        backgroundColor: isAppBarBlue
            ? const Color(0x64c3e7fd).withOpacity(1)
            : Colors.transparent, // Set to your desired transparent color
        elevation: isAppBarBlue ? 1 : 0, // Set elevation based on color
      ),
      body: Stack(
        children: [
          _buildContent(),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Offstage(
                offstage: MediaQuery.of(context).viewInsets.bottom > 0,
                child: Image.asset(
                  'assets/images/Grass_green.png',
                  fit: BoxFit.fitWidth, // Shrink the width to fit the screen
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (showLogin) {
      return _buildLoginForm();
    } else if (showSignUp) {
      return _buildSignUpForm();
    } else {
      return _buildInitialButtons();
    }
  }

  Widget _buildInitialButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/DSlogo_blue.png',
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () => setState(() {
            showLogin = true;
            isAppBarBlue = true; // Set blue color when login is clicked
          }),
          child: Text('Login', style: TextStyle(color: Colors.grey[800])),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0x64c3e7fd).withOpacity(1),
          ),
        ),
        SizedBox(height: 20),
        OutlinedButton(
          onPressed: () => setState(() {
            showSignUp = true;
            isAppBarBlue = true; // Set blue color when sign up is clicked
          }),
          child: Text('Sign Up', style: TextStyle(color: Colors.grey[800])),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextFormField(decoration: InputDecoration(labelText: 'Email')),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Handle login logic
          },
          child: Text('Login', style: TextStyle(color: Colors.grey[800])),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0x64c3e7fd).withOpacity(1),
          ),
        ),
        SizedBox(height: 20),
        OutlinedButton(
          onPressed: () => setState(() {
            showLogin = false;
            showSignUp = true;
          }),
          child: Text('Sign Up', style: TextStyle(color: Colors.grey[800])),
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextFormField(
            controller: firstNameController,
            decoration: InputDecoration(labelText: 'First Name'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextFormField(
            controller: lastNameController,
            decoration: InputDecoration(labelText: 'Last Name'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextFormField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextFormField(
            controller: passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (firstNameController.text.isNotEmpty &&
                lastNameController.text.isNotEmpty &&
                emailController.text.isNotEmpty &&
                passwordController.text.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileView()),
              );
            } else {
              // Handle empty fields
            }
          },
          child: Text('Sign Up', style: TextStyle(color: Colors.grey[800])),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0x64c3e7fd).withOpacity(1),
          ),
        ),
        SizedBox(height: 20),
        OutlinedButton(
          onPressed: () => setState(() {
            showSignUp = false;
            showLogin = true;
          }),
          child: Text('Login', style: TextStyle(color: Colors.grey[800])),
        ),
      ],
    );
  }
}
