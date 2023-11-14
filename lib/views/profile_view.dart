import 'package:flutter/material.dart';
import '../view_models/profile_view_model.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  late ProfileViewModel _viewModel;
  int currentImageIndex = 0;

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
    "Energetic", "Loyal", "Intelligent", "Independent"
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
              onPressed: () {},
            ),
          ),
          centerTitle: true,
        backgroundColor: const Color(0xc3e7fdff).withOpacity(.5)
      ),

        body: Column(
            children: [
              LayoutBuilder(
                builder: (context,constraints) =>

                    ToggleButtons(
                      //style ( I basically stole this from Tinder)
                        renderBorder: false,
                        color: Colors.black,
                        selectedColor: Colors.lightBlueAccent,
                        fillColor: Colors.grey[50],
                        constraints: BoxConstraints.expand(width: (constraints.maxWidth)/2),
                        children: [

                           Text(
                              'Edit',
                              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                            ),


                          Text(
                            'Preview',
                            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                        ],
                        onPressed: (int index){
                          setState(() {
                            for (int i = 0; i < isSelected.length; i++) {
                              isSelected[i] = i == index;
                              if(index==0){
                                _isEdit=true;
                              }
                              else
                                _isEdit =false;
                            }
                          }
                          );
                        },
                        isSelected: isSelected
                    ),
              ),
              Expanded(
                child: _isEdit ? _buildEditView() : _buildPreviewView(),
              ),
            ]
        )
    );
  }

  Widget _buildEditView() {
    Widget _imageSelector(int imageNumber) {
      return GestureDetector(
        onTap: () => showImagePicker(imageNumber),
        child: Container(
          height: 100,
          width: 100,
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
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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

                onSaved: (value) => _viewModel.updateDogName(value),

              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Dog Age',
                    labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                keyboardType: TextInputType.number,
                initialValue: _viewModel.profile.dogAge ?? "",
                onSaved: (value) => _viewModel.updateDogAge(value),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Dog Breed',
                    labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                initialValue: _viewModel.profile.dogBreed ?? "",
                onSaved: (value) => _viewModel.updateDogBreed(value),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Dog Size',
                    labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                items: ['Extra Small', 'Small', 'Medium', 'Large', 'Extra Large']
                    .map((size) => DropdownMenuItem(value: size, child: Text(size)))
                    .toList(),
                //value: _viewModel.profile.dogSize ?? '',
                onChanged: (String? newValue) {
                  _viewModel.updateDogSize(newValue);
                },
                onSaved: (value) => _viewModel.updateDogSize(value),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Personality Traits",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Wrap(
                children: allTraits.map((trait) {
                  return CheckboxListTile(
                    title: Text(trait),
                    value: selectedTraits.contains(trait),
                    onChanged: selectedTraits.length < 3 || selectedTraits.contains(trait)
                        ? (bool? value) {
                      if (value == true) {
                        if (selectedTraits.length < 3) {
                          selectedTraits.add(trait);
                        }
                      } else {
                        selectedTraits.remove(trait);
                      }
                      _viewModel.updatePersonalityTraits(selectedTraits);
                      setState(() {}); // Update the UI
                    }
                        : null,
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _imagePreview(),
          Text('Dog Name: ${_viewModel.profile.dogName ?? "Not set"}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text('Dog Age: ${_viewModel.profile.dogAge ?? "Not set"}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text('Dog Breed: ${_viewModel.profile.dogBreed ?? "Not set"}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text('Dog Size: ${_viewModel.profile.dogSize ?? "Not set"}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text("Personality Traits",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ..._viewModel.profile.personalityTraits.map((trait) {
            return Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                trait,
                style: TextStyle(fontSize: 16),
              ),
            );
          }).toList(),
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
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.grey[300],
          image: DecorationImage(
            image: AssetImage(selectedImages[currentImageIndex]!),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
