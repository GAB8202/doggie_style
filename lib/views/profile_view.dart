import 'package:flutter/material.dart';
import '../views/home_view.dart';
import '../view_models/profile_view_model.dart';
import 'settings_view.dart';

class ProfileView extends StatefulWidget {
  final ProfileViewModel viewModel;

  ProfileView({Key? key, required this.viewModel}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  late ProfileViewModel _viewModel = widget.viewModel;
  int currentImageIndex = 0;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _viewModel.onProfileUpdated = () => setState(() {});
    if (_viewModel.profile.personalityTraits != null) {
      selectedTraits = List.from(_viewModel.profile.personalityTraits!);
    }
  }

  bool _isEdit = true;
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Choose a picture",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              //for clearing image
              TextButton(
                onPressed: () {
                  _viewModel.clearImage(imageNumber);
                  Navigator.of(context).pop();
                },

                child: Text(
                  'Clear Image',
                  style: TextStyle(
                    color: Colors.red,
                      fontSize: 18, fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          ),
          //the selection of images
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  children: <String>[
                    'assets/profile_pics/dog1.jpg',
                    'assets/profile_pics/dog2.jpg',
                    'assets/profile_pics/dog3.jpg',
                    'assets/profile_pics/dog4.jpg',
                    'assets/profile_pics/dog5.jpg',
                    'assets/profile_pics/dog6.jpg',
                    'assets/profile_pics/dog7.jpg',
                    'assets/profile_pics/dog8.jpg',
                    'assets/profile_pics/dog9.jpg',
                    'assets/profile_pics/dog10.jpg',
                    'assets/profile_pics/dog11.jpg',
                    'assets/profile_pics/dog12.jpg',
                    'assets/profile_pics/dog13.jpg',
                    'assets/profile_pics/dog14.jpg',
                    'assets/profile_pics/dog15.jpg',
                    'assets/profile_pics/dog16.jpg',
                    'assets/profile_pics/dog18.jpg',
                    'assets/profile_pics/dog19.jpg',
                    'assets/profile_pics/dog20.jpg',
                  ].map((String asset) {
                    return GestureDetector(
                      onTap: () {
                        _viewModel.selectImage(imageNumber, asset);
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Image.asset(
                          asset,
                          scale: 0.5,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeView(viewModel: _viewModel)),
              (Route<dynamic> route) => false,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Transform.scale(
            scale: 2,
            child: IconButton(
              icon: Image.asset('assets/images/DSLogoPaw_white.png'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeView(viewModel: _viewModel)),
                );
              },
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0x64c3e7fd).withOpacity(1),
          actions: [
            IconButton(
              icon:  Icon(Icons.settings,color: Colors.white.withOpacity(1)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingView(viewModel: _viewModel)),
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
                          color: Colors.grey,
                          width: .5,
                        ),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 0;
                          _isEdit = true;
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
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Padding(
          padding: EdgeInsets.all(16.0),
          child: FloatingActionButton.extended(
            backgroundColor: Color(0x64c3e7fd).withOpacity(1),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                _viewModel.saveProfile(_viewModel.profile.email);
                FocusScope.of(context).unfocus();
                _showSavedSnackbar();
              }
            },
            label: Text(
              'Save Profile',
              style: TextStyle(fontFamily: 'Indie Flower', fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black),
            ),
          ),
        ),

      ),

    );

  }
  void _showSavedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile Successfully Saved',
            style: TextStyle(fontFamily: 'Indie Flower', fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black)),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildEditView() {
    Widget _imageSelector(int imageNumber) {
      return GestureDetector(
        onTap: () => showImagePicker(imageNumber),
        child: Container(
          height: 150,
          width:  (MediaQuery.of(context).size.width/3)-25,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(5),
            image: _viewModel.getImage(imageNumber) != 'null' && _viewModel.getImage(imageNumber) != ''
                ? DecorationImage(
              image: AssetImage(_viewModel.getImage(imageNumber)),
              fit: BoxFit.cover,
            ) : null,

          ),
          child: _viewModel.getImage(imageNumber) == 'null' || _viewModel.getImage(imageNumber) == ''
              ? Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Select Image \n',
                  ),
                  TextSpan(
                    text: '$imageNumber',
                    style: TextStyle(fontSize: 24, ),
                  ),
                ],
              ),
            ),
          )
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _imageSelector(1),
                    _imageSelector(2),
                    _imageSelector(3),
                    _imageSelector(4),
                  ],
                ),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Dog Name',
                    labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                initialValue: _viewModel.profile.dogName == "null" ? "" : _viewModel.profile.dogName ?? "",
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
                initialValue: _viewModel.profile.dogAge == "null" ? "" : _viewModel.profile.dogAge ?? "",
                onSaved: (value) {
                  if (value != "") {
                    _viewModel.updateDogAge(value);
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Dog Breed',
                    labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                initialValue: _viewModel.profile.dogBreed == "null" ? "" : _viewModel.profile.dogBreed ?? "",
                onSaved: (value) {
                  if (value != "") {
                    _viewModel.updateDogBreed(value);
                  }
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Dog Size',
                  labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                items: ['Extra Small', 'Small', 'Medium', 'Large', 'Extra Large']
                    .where((size) => size.isNotEmpty) // filter out empty strings
                    .map((size) => DropdownMenuItem(value: size, child: Text(size)))
                    .toList(),
                value: _viewModel.profile.dogSize == '' ? null : _viewModel.profile.dogSize,
                onChanged: (String? newValue) {
                  _viewModel.updateDogSize(newValue == 'null' ? null : newValue);
                },
                onSaved: (value) => _viewModel.updateDogSize(value == 'null' ? null : value),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 0.0),
                      child: Text(
                        "Personality Traits",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Select up to 3",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
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
                            if (selectedTraits.length >= 3) {
                              selectedTraits.removeAt(0);
                              selectedTraits.add(trait);
                            } else {
                              selectedTraits.add(trait);
                            }
                          }
                        });
                        _viewModel.updatePersonalityTraits(selectedTraits);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: isSelected ? Colors.green[500] : const Color(0x64c3e7fd).withOpacity(1),
                      ),
                      child: Text(trait, style: TextStyle(color: Colors.grey[800]),),
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

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewView() {
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
                    text: '  ${_viewModel.profile.dogName?.isNotEmpty ?? false ? _viewModel.profile.dogName : "Not set"}',
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
                    text: '  ${_viewModel.profile.dogAge?.isNotEmpty ?? false ? _viewModel.profile.dogName : "Not set"}',
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
                    text: '  ${_viewModel.profile.dogBreed?.isNotEmpty ?? false ? _viewModel.profile.dogName : "Not set"}',
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
                    text: '  ${_viewModel.profile.dogSize?.isNotEmpty ?? false ? _viewModel.profile.dogName : "Not set"}',
                    style: TextStyle(fontFamily: 'Oswald',fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black)
                ),
              ],
            ),
          ),

          Padding( padding: const EdgeInsets.all(8.0),),
          Text("Personality Traits:",
            style: TextStyle(fontFamily: 'Indie Flower',fontSize: 18, fontWeight: FontWeight.bold),
          ),
          (_viewModel.profile.personalityTraits == null || _viewModel.profile.personalityTraits!.isEmpty || _viewModel.profile.personalityTraits!.every((trait) => trait.isEmpty))
              ? Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Wrap(
              direction: Axis.horizontal,
              children: [
                Text(
                  'None Selected',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
              : Wrap(
            direction: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 32.0),
                child: Text(
                  _viewModel.profile.personalityTraits!.join(', '),
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
      _viewModel.profile.imageAsset4,
    ].where((image) => image != null && image != 'null' && image != '').toList();

    if (selectedImages.isEmpty || selectedImages == null) {
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
            image: selectedImages[currentImageIndex] != null
                ? AssetImage(selectedImages[currentImageIndex]!)
                : AssetImage('assets/images/DSLogo_white.png'),
            fit: selectedImages[currentImageIndex] == 'assets/images/DSLogo_white.png'
                ? BoxFit.fitWidth
                : BoxFit.cover,
          ),
        ),
      ),
    );
  }
}