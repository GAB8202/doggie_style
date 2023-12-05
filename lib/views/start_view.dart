import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import 'profile_view.dart';
import 'dart:io';
import '../view_models/profile_view_model.dart';
import 'package:path_provider/path_provider.dart';
import 'home_view.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool showLogin = false;
  bool showSignUp = false;
  var _viewModel = ProfileViewModel();

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
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
        TextFormField(
          controller: passwordController,
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
              final directory = await getApplicationDocumentsDirectory();
              final path = directory.path;
              final file = File('$path/profile_data.csv');

              final profiles = await file.readAsString();
              final credentials = CsvToListConverter().convert(profiles);
              bool credentialsExist = credentials.any((row) => row[9] == emailController.text && row[10] == passwordController.text);

              if (credentialsExist) {
                ProfileModel? userProfile = await _viewModel.getProfileByEmail(emailController.text);
                _viewModel.updateDogAge(userProfile?.dogAge);
                _viewModel.updateDogBreed(userProfile?.dogBreed);
                _viewModel.updateDogName(userProfile?.dogName);
                _viewModel.updateDogSize(userProfile?.dogSize);
                _viewModel.updateEmail(userProfile?.email);
                _viewModel.updatePassword(userProfile?.password);
                _viewModel.updatePersonalityTraits(userProfile?.personalityTraits);
                _viewModel.updateImage1(userProfile?.imageAsset1);
                _viewModel.updateImage2(userProfile?.imageAsset2);
                _viewModel.updateImage3(userProfile?.imageAsset3);
                _viewModel.updateImage4(userProfile?.imageAsset4);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileView(viewModel: _viewModel)),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Invalid email or password'),
                      content: Text('The entered email or password is incorrect.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            }
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
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormField(controller: firstNameController, decoration: InputDecoration(labelText: 'First Name')),
        TextFormField(controller: lastNameController, decoration: InputDecoration(labelText: 'Last Name')),
        TextFormField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
        TextFormField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            if (firstNameController.text.isNotEmpty &&
                lastNameController.text.isNotEmpty &&
                emailController.text.isNotEmpty &&
                passwordController.text.isNotEmpty) {

              if(isNumericOnly(emailController.text) || isNumericOnly(passwordController.text)) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Invalid Input'),
                      content: Text('Email or password cannot consist solely of numbers.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
                return;
              }

              final directory = await getApplicationDocumentsDirectory();
              final path = directory.path;
              final file = File('$path/profile_data.csv');
              await file.writeAsString("");

              final profiles = await file.readAsString();
              final emails = CsvToListConverter().convert(profiles);
              bool emailExists = emails.any((row) => row[9] == emailController.text);

              if (emailExists) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Email already exists'),
                      content: Text('An account with this email already exists.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
                return;
              }

              ProfileModel newProfile = ProfileModel(
                  email: emailController.text,
                  password: passwordController.text
              );

              List<List<dynamic>> existingProfiles = const CsvToListConverter().convert(profiles);
              existingProfiles.add(_viewModel.toCsvRow(newProfile));
              String newCsvData = const ListToCsvConverter().convert(existingProfiles);
              await file.writeAsString("");
              await file.writeAsString(newCsvData, mode: FileMode.append);
              _viewModel.updateDogAge(newProfile?.dogAge);
              _viewModel.updateDogBreed(newProfile?.dogBreed);
              _viewModel.updateDogName(newProfile?.dogName);
              _viewModel.updateDogSize(newProfile?.dogSize);
              _viewModel.updateEmail(newProfile?.email);
              _viewModel.updatePassword(newProfile?.password);
              _viewModel.updatePersonalityTraits(newProfile?.personalityTraits);
              _viewModel.updateImage1(newProfile?.imageAsset1);
              _viewModel.updateImage2(newProfile?.imageAsset2);
              _viewModel.updateImage3(newProfile?.imageAsset3);
              _viewModel.updateImage4(newProfile?.imageAsset4);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileView(viewModel: _viewModel,)),
              );
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

  bool isNumericOnly(String str) {
    return str.isNotEmpty && str.runes.every((rune) => '0'.codeUnitAt(0) <= rune && rune <= '9'.codeUnitAt(0));
  }
}