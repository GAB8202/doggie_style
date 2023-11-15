import 'package:flutter/material.dart';
import 'package:navigation/views/home_view.dart';
import '../view_models/profile_view_model.dart';
import 'settings_view.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  late ProfileViewModel _viewModel;
  int currentImageIndex = 0;
  int _selectedIndex = 0; // Track the selected index

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel();
    _viewModel.onProfileUpdated = () => setState(() {}); // Set the callback
  }

  bool _isEdit = true; // Toggle flag
  List<bool>isSelected = [true, false];

  List<String> allTraits = [
    "Friendly", "Playful", "Calm", "Protective", "Curious",
    "Energetic", "Loyal", "Intelligent", "Independent", "Gentle", "Kid Friendly"
  ];
  List<String> selectedTraits = [];

  void showImagePicker(int imageNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose a picture"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <String>[
                'assets/profile_pics/dog1.jpg',
                'assets/profile_pics/dog2.jpg',
                'assets/profile_pics/dog5.jpg',
                //
              ].map((String asset) {
                return GestureDetector(
                  child: Image.asset(asset, width: 100, height: 100),
                  onTap: () {
                    _viewModel.selectImage(imageNumber, asset);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
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
          centerTitle: true,
          backgroundColor: const Color(0xc3e7fdff).withOpacity(.5),
          actions: [
            IconButton(
            icon:  Icon(Icons.settings,color: Colors.white.withOpacity(1)),
            tooltip: 'Open shopping cart',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingView()),
              );
            },
          ),
          ],
      ),

        body:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.grey, // Border color for the right side of "Edit"
                          width: .5, // Border width
                        ),
                      ),
                    ),
                   child: TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 0; // Set the selected index to 0 (Edit)
                          _isEdit = true; // Switch to Edit view
                        });
                      },
                      child: Text(
                        'Edit',
                        style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                          return _selectedIndex == 0 ? Colors.black : Colors.grey;
                        }),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Colors.grey,
                          width: .5,
                        ),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1;
                          _isEdit = false;
                        });
                      },
                      child: Text(
                        'Preview',
                        style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                          return _selectedIndex == 1 ? Colors.black : Colors.grey;
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: _selectedIndex == 0 ? _buildEditView() : _buildPreviewView(),
            ),
          ],
        )
    );
  }

  Widget _buildEditView() {
    Widget _imageSelector(int imageNumber) {
      return GestureDetector(
        onTap: () => showImagePicker(imageNumber),
        child: Container(
          height: 150,
          width:  (MediaQuery.of(context).size.width/3)-6,
          decoration: BoxDecoration(
            color: Colors.grey[300], // Default background color
            border: Border.all(color: Colors.black),
            image: _viewModel.getImage(imageNumber) != null
                ? DecorationImage(
              image: AssetImage(_viewModel.getImage(imageNumber)!),
              fit: BoxFit.cover,
            ) : null,
          ),
          child: _viewModel.getImage(imageNumber) == null
              ? Center(child: Text('Select Image $imageNumber', textAlign: TextAlign.center))
              : SizedBox(),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(0.0),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _imageSelector(1),
                  _imageSelector(2),
                  _imageSelector(3),
                ],
              ),
            //crossAxisAlignment: CrossAxisAlignment.start
              TextFormField(
                decoration: InputDecoration(labelText: 'Dog Name',
                    labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                initialValue: _viewModel.profile.dogName ?? "",
                onSaved: (value) {
                  if (value != "") {
                    _viewModel.updateDogName(value);
                  }
                },
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Dog Age',
                    labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                keyboardType: TextInputType.number,
                initialValue: _viewModel.profile.dogAge ?? "",
                onSaved: (value) {
                  if (value != "") {
                    _viewModel.updateDogAge(value);
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Dog Breed',
                    labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                initialValue: _viewModel.profile.dogBreed ?? "",
                onSaved: (value) {
                  if (value != "") {
                    _viewModel.updateDogBreed(value);
                  }
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Dog Size',
                    labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                items: ['Extra Small', 'Small', 'Medium', 'Large', 'Extra Large']
                    .map((size) => DropdownMenuItem(value: size, child: Text(size)))
                    .toList(),
                value: _viewModel.profile.dogSize ?? null,
                onChanged: (String? newValue) {
                  _viewModel.updateDogSize(newValue);
                },
                onSaved: (value) => _viewModel.updateDogSize(value),
              ),

              Padding( //this is driving me crazy I can't get it to align to left
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                 child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                  // textDirection: TextDirection.ltr,
                   children: <Widget>[
                     Text(
                       "Personality Traits",
                       style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                       textAlign: TextAlign.left, //I can't figure this out
                     ),
                   ]
                ),

              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: allTraits.map((trait) {
                    bool isSelected = selectedTraits.contains(trait);
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (isSelected) {
                            selectedTraits.remove(trait);
                          } else {
                            selectedTraits.add(trait);
                          }
                        });
                        _viewModel.updatePersonalityTraits(selectedTraits);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: isSelected ? const Color(0x006400).withOpacity(.5) : const Color(0xc3e7fdff).withOpacity(.5),
                      ),
                      child: Text(trait),
                    );
                  }).toList(),
                ),
              ),
              const Divider(
                height: 20,
                thickness: 1,
                indent: 0,
                endIndent: 0,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xc3e7fdff).withOpacity(.5)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _viewModel.saveProfile();
                    }
                  },
                  child: Text('Save Profile',
                      style: TextStyle(fontFamily: 'Indie Flower', fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewView() {
    // This is where you display the read-only profile info
    return SingleChildScrollView(
      padding:  EdgeInsets.all(((MediaQuery.of(context).size.width)-300)/2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _imagePreview(),
          RichText(
            text: TextSpan(
              text: 'Dog Name:',
              style: TextStyle(fontFamily: 'Indie Flower',fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              children: [
                TextSpan(
                  text: '  ${_viewModel.profile.dogName ?? "Not set"}',
                    style: TextStyle(fontFamily: 'Oswald',fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black)
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Dog Age:',
              style: TextStyle(fontFamily: 'Indie Flower',fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              children: [
                TextSpan(
                    text: '  ${_viewModel.profile.dogAge ?? "Not set"}',
                    style: TextStyle(fontFamily: 'Oswald',fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black)
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Dog Breed:',
              style: TextStyle(fontFamily: 'Indie Flower',fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              children: [
                TextSpan(
                    text: '  ${_viewModel.profile.dogBreed ?? "Not set"}',
                    style: TextStyle(fontFamily: 'Oswald',fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black)
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Dog Size:',
              style: TextStyle(fontFamily: 'Indie Flower',fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              children: [
                TextSpan(
                    text: '  ${_viewModel.profile.dogSize ?? "Not set"}',
                    style: TextStyle(fontFamily: 'Oswald',fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black)
                ),
              ],
            ),
          ),

          Padding( padding: const EdgeInsets.all(8.0),),
          Text("Personality Traits:",
              style: TextStyle(fontFamily: 'Indie Flower',fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Wrap(
            direction: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 32.0),
                child: Text(
                  _viewModel.profile.personalityTraits.join(', '),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imagePreview() {

    List<String?> selectedImages = [
      _viewModel.profile.imageAsset1,
      _viewModel.profile.imageAsset2,
      _viewModel.profile.imageAsset3,
    ].where((image) => image != null).toList();

    if (selectedImages.isEmpty) {
      selectedImages.add('assets/images/DSLogo_white.png');
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          currentImageIndex = (currentImageIndex + 1) % selectedImages.length;
        });
      },
      child: Container(
        height: 450,
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[300],
          image: DecorationImage(
            image: AssetImage(selectedImages[currentImageIndex]!),
            fit: selectedImages[currentImageIndex] == 'assets/images/DSLogo_white.png'
                ? BoxFit.fitWidth // Set BoxFit to the desired value when the condition is true
                : BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
