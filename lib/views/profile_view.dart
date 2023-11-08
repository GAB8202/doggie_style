import 'package:flutter/material.dart';
import '../view_models/profile_view_model.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  final ProfileViewModel _viewModel = ProfileViewModel();

  bool _isEdit = true; // Toggle flag
  List<bool>isSelected = [true, false];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Doggie Style',
        style: TextStyle(fontFamily: 'Indie Flower', fontSize: 36, fontWeight: FontWeight.bold)
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
                    color: Colors.black,
                    selectedColor: Colors.lightBlueAccent,
                    fillColor: Colors.white,
                   // borderRadius: BorderRadius.vertical({Radius top = Radius.zero, Radius bottom = Radius.zero}),
                    
                    constraints: BoxConstraints.expand(width: (constraints.maxWidth-3)/2),
                    children: [
                      Text(
                        'Edit',
                      ),
                      Text(
                        'Preview',
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
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(

                decoration: InputDecoration(labelText: 'Dog Name',
                    labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                onSaved: (value) => _viewModel.updateDogName(value),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Dog Age',
                    labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                keyboardType: TextInputType.number,
                onSaved: (value) => _viewModel.updateDogAge(value),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Dog Breed',
                    labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                onSaved: (value) => _viewModel.updateDogBreed(value),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Dog Size',
                    labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                items: ['Extra Small', 'Small', 'Medium', 'Large', 'Extra Large']
                    .map((size) => DropdownMenuItem(value: size, child: Text(size)))
                    .toList(),
                onChanged: (String? newValue) {
                  // No need to call setState if you don't need to rebuild the UI
                  _viewModel.updateDogSize(newValue);
                },
                onSaved: (value) => _viewModel.updateDogSize(value),
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
                      style: TextStyle(fontFamily: 'Oswald', fontSize: 18, fontWeight: FontWeight.bold)),
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
          Text('Dog Name: ${_viewModel.profile.dogName ?? "Not set"}'),
          Text('Dog Age: ${_viewModel.profile.dogAge ?? "Not set"}'),
          Text('Dog Breed: ${_viewModel.profile.dogBreed ?? "Not set"}'),
          Text('Dog Size: ${_viewModel.profile.dogSize ?? "Not set"}'),
          // Add more fields as needed
        ],
      ),
    );
  }
}
