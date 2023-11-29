import 'package:flutter/material.dart';
import 'profile_view.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool showLogin = false;
  bool showSignUp = false;

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
      body: Center(
        child: showLogin
            ? _buildLoginForm()
            : showSignUp
            ? _buildSignUpForm()
            : _buildInitialButtons(),
      ),
    );
  }

  // Initial buttons view
  Widget _buildInitialButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () => setState(() => showLogin = true),
          child: Text('Login'),
        ),
        SizedBox(height: 20),
        OutlinedButton(
          onPressed: () => setState(() => showSignUp = true),
          child: Text('Sign Up'),
        ),
      ],
    );
  }

  // Login form view
  Widget _buildLoginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormField(decoration: InputDecoration(labelText: 'Email')),
        TextFormField(
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Handle login logic
          },
          child: Text('Login'),
        ),
        SizedBox(height: 20),
        OutlinedButton(
          onPressed: () => setState(() {
            showLogin = false;
            showSignUp = true;
          }),
          child: Text('Sign Up'),
        ),
      ],
    );
  }

  // Sign-up form view
  Widget _buildSignUpForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormField(controller: firstNameController, decoration: InputDecoration(labelText: 'First Name')),
        TextFormField(controller: lastNameController, decoration: InputDecoration(labelText: 'Last Name')),
        TextFormField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
        TextFormField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
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
          child: Text('Sign Up'),
        ),
        SizedBox(height: 20),
        OutlinedButton(
          onPressed: () => setState(() {
            showSignUp = false;
            showLogin = true;
          }),
          child: Text('Login'),
        ),
      ],
    );
  }
}