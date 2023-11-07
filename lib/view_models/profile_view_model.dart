import '../models/profile_model.dart';

class ProfileViewModel {
  ProfileModel _profile = ProfileModel();

  ProfileModel get profile => _profile;

  void updateDogName(String? value) {
    _profile.dogName = value;
  }

  void updateDogAge(String? value) {
    _profile.dogAge = value;
  }

  void updateDogBreed(String? value) {
    _profile.dogBreed = value;
  }

  void updateDogSize(String? value) {
    _profile.dogSize = value;
  }

  void saveProfile() {
    // Implement your save functionality here.
    print('Dog Name: ${_profile.dogName}');
    print('Dog Age: ${_profile.dogAge}');
    print('Dog Breed: ${_profile.dogBreed}');
    print('Dog Size: ${_profile.dogSize}');
  }
}
