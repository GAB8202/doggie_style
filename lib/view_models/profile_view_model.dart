import '../models/profile_model.dart';
import 'dart:io';

class ProfileViewModel {
  final ProfileModel _profile = ProfileModel();

  Function()? onProfileUpdated;

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

  void selectImage(int imageNumber, String selectedAsset) {
    switch (imageNumber) {
      case 1:
        _profile.imageAsset1 = selectedAsset;
        break;
      case 2:
        _profile.imageAsset2 = selectedAsset;
        break;
      case 3:
        _profile.imageAsset3 = selectedAsset;
        break;
    }
    onProfileUpdated?.call();
  }

  String? getImage(int imageNumber) {
    switch (imageNumber) {
      case 1:
        return _profile.imageAsset1;
      case 2:
        return _profile.imageAsset2;
      case 3:
        return _profile.imageAsset3;
      default:
        return null;
    }
  }

  void updatePersonalityTraits(List<String> traits) {
    _profile.personalityTraits = traits;
    onProfileUpdated?.call();
  }

  void saveProfile() {
    print('Dog Name: ${_profile.dogName}');
    print('Dog Age: ${_profile.dogAge}');
    print('Dog Breed: ${_profile.dogBreed}');
    print('Dog Size: ${_profile.dogSize}');
    print('Image 1: ${_profile.imageAsset1}');
    print('Image 2: ${_profile.imageAsset2}');
    print('Image 3: ${_profile.imageAsset3}');
    print('Personality Traits:');
    for (var trait in _profile.personalityTraits) {
      print(trait);
    }
  }
}