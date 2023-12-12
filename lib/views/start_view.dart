import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import 'profile_view.dart';
import 'dart:io';
import '../view_models/profile_view_model.dart';
import 'package:path_provider/path_provider.dart';



class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool showLogin = false;
  bool showSignUp = false;
  bool isAppBarBlue = false; // Added a flag to track the blue color
  final _viewModel = ProfileViewModel();

  @override
  Widget build(BuildContext context) {
    //_viewModel.clearProfileDataFile();
    return Scaffold(
      appBar: AppBar(

        // Add the leading back arrow button
        leading: showLogin || showSignUp
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() {
            showLogin = false;
            showSignUp = false;
            isAppBarBlue = false;
          }),
        )
            : null,
        backgroundColor: isAppBarBlue
            ? const Color(0x64c3e7fd).withOpacity(1)
            : Colors.transparent,
        elevation: isAppBarBlue ? 1 : 0,
      ),
      body: Stack(
        children: [
          _buildContent(),
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Offstage(
                offstage: MediaQuery.of(context).viewInsets.bottom > 0,
                child: Image.asset(
                  'assets/images/Grass_green.png',
                  fit: BoxFit.fitWidth,
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
              'assets/images/DSLogo_blue.png',
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: ElevatedButton(
            onPressed: () => setState(() {
              showLogin = true;
              isAppBarBlue = true;
            }),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0x64c3e7fd).withOpacity(1),
              minimumSize: Size(125, 60),
            ),
            child: Text('Login', style: TextStyle(color: Colors.grey[800], fontSize: 25,)),
          ),
        ),

        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: () => setState(() {
            showSignUp = true;
            isAppBarBlue = true;
          }),
          style: OutlinedButton.styleFrom(
            minimumSize: Size(90, 50),
          ),
          child: Text('Sign Up', style: TextStyle(color: Colors.grey[800], fontSize: 18,)),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
        ),

        Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
              final directory = await getApplicationDocumentsDirectory();
              final path = directory.path;
              final file = File('$path/profile_data.csv');

              final profiles = await file.readAsString();
              final credentials = const CsvToListConverter().convert(profiles);
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
                      title: const Text('Invalid email or password'),
                      content: const Text('The entered email or password is incorrect.'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
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
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0x64c3e7fd).withOpacity(1),
            minimumSize: Size(125, 60),
          ),
          child: Text('Login', style: TextStyle(color: Colors.grey[800], fontSize: 25)),
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: () => setState(() {
            showLogin = false;
            showSignUp = true;
          }),
          style: OutlinedButton.styleFrom(
            minimumSize: Size(90, 50),
          ),
          child: Text('Sign Up', style: TextStyle(color: Colors.grey[800], fontSize: 18)),
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextFormField(
            controller: firstNameController,
            decoration: const InputDecoration(labelText: 'First Name'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextFormField(
            controller: lastNameController,
            decoration: const InputDecoration(labelText: 'Last Name'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextFormField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
        ),
        const SizedBox(height: 20),
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
                      title: const Text('Invalid Input'),
                      content: const Text('Email or password cannot consist solely of numbers.'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
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
              final emails = const CsvToListConverter().convert(profiles);
              bool emailExists = emails.any((row) => row[9] == emailController.text);

              if (emailExists) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Email already exists'),
                      content: const Text('An account with this email already exists.'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
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
              _viewModel.updateDogAge(newProfile.dogAge);
              _viewModel.updateDogBreed(newProfile.dogBreed);
              _viewModel.updateDogName(newProfile.dogName);
              _viewModel.updateDogSize(newProfile.dogSize);
              _viewModel.updateEmail(newProfile.email);
              _viewModel.updatePassword(newProfile.password);
              _viewModel.updatePersonalityTraits(newProfile.personalityTraits);
              _viewModel.updateImage1(newProfile.imageAsset1);
              _viewModel.updateImage2(newProfile.imageAsset2);
              _viewModel.updateImage3(newProfile.imageAsset3);
              _viewModel.updateImage4(newProfile.imageAsset4);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileView(viewModel: _viewModel,)),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0x64c3e7fd).withOpacity(1),
            minimumSize: Size(125, 60),
          ),
          child: Text('Sign Up', style: TextStyle(color: Colors.grey[800],fontSize: 25)),
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: () => setState(() {
            showSignUp = false;
            showLogin = true;
          }),
          style: OutlinedButton.styleFrom(
            minimumSize: Size(90, 50),
          ),
          child: Text('Login', style: TextStyle(color: Colors.grey[800], fontSize: 18)),
        ),
      ],
    );
  }

  bool isNumericOnly(String str) {
    return str.isNotEmpty && str.runes.every((rune) => '0'.codeUnitAt(0) <= rune && rune <= '9'.codeUnitAt(0));
  }
}
