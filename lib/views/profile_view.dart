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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doggie Style'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            // Toggle bar directly under the AppBar
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Edit button
                ElevatedButton(
                  onPressed: () => setState(() => _isEdit = true),
                  child: Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    primary: _isEdit ? Colors.blue : Colors.grey,
                  ),
                ),
                SizedBox(width: 8),
                // Preview button
                ElevatedButton(
                  onPressed: () => setState(() => _isEdit = false),
                  child: Text('Preview'),
                  style: ElevatedButton.styleFrom(
                    primary: !_isEdit ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isEdit ? _buildEditView() : _buildPreviewView(),
          ),
        ],
      ),
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
                decoration: InputDecoration(labelText: 'Dog Name'),
                onSaved: (value) => _viewModel.updateDogName(value),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Dog Age'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _viewModel.updateDogAge(value),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Dog Breed'),
                onSaved: (value) => _viewModel.updateDogBreed(value),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Dog Size'),
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
                  child: Text('Save Profile'),
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
