import '../models/profile_model.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

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

  void updateEmail(String? value) {
    _profile.email = value;
  }

  void updatePassword(String? value) {
    _profile.password = value;
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
      case 4:
        _profile.imageAsset4 = selectedAsset;
        break;
    }
    onProfileUpdated?.call();
  }

  String getImage(int imageNumber) {
    switch (imageNumber) {
      case 1:
        return _profile.imageAsset1 ?? "null";
      case 2:
        return _profile.imageAsset2 ?? "null";
      case 3:
        return _profile.imageAsset3 ?? "null";
      case 4:
        return _profile.imageAsset4 ?? "null";
      default:
        return "null";
    }
  }

  void updatePersonalityTraits(List<String>? traits) {
    _profile.personalityTraits = traits;
    onProfileUpdated?.call();
  }

  void updateImage1(String? value) {
    _profile.imageAsset1 = value;
  }

  void updateImage2(String? value) {
    _profile.imageAsset2 = value;
  }

  void updateImage3(String? value) {
    _profile.imageAsset3 = value;
  }

  void updateImage4(String? value) {
    _profile.imageAsset4 = value;
  }

  Future<void> saveProfile(String? email) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/profile_data.csv');

    String csvContent = await file.readAsString();
    List<List<dynamic>> rows = const CsvToListConverter().convert(csvContent);

    for (int i = 0; i < rows.length; i++) {
      if (rows[i].isNotEmpty && rows[i][9] == email) {
        rows[i] = toCsvRow(_profile);
        break;
      }
    }

    String updatedCsvContent = const ListToCsvConverter().convert(rows);
    await file.writeAsString("");
    await file.writeAsString(updatedCsvContent, mode: FileMode.write);
  }

  List<dynamic> toCsvRow(ProfileModel profile) {
    return [profile.dogName, profile.dogAge, profile.dogBreed, profile.dogSize, profile.imageAsset1, profile.imageAsset2, profile.imageAsset3, profile.imageAsset4, profile.personalityTraits?.join(';'), profile.email, profile.password];
  }

  Future<ProfileModel?> getProfileByEmail(String email) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/profile_data.csv');

    try {
      final profilesCsv = await file.readAsString();
      final List<List<dynamic>> credentials = const CsvToListConverter().convert(profilesCsv);

      for (List<dynamic> row in credentials) {
        if (row.isNotEmpty && row[9] == email) { // Assuming email is at index 9
          return ProfileModel(
            dogName: row[0],
            dogAge: row[1],
            dogBreed: row[2],
            dogSize: row[3],
            imageAsset1: row[4],
            imageAsset2: row[5],
            imageAsset3: row[6],
            imageAsset4: row[7],
            personalityTraits: row[8].split(';'),
            email: row[9],
            password: row[10],
          );
        }
      }
    } catch (e) {
      print("Error occurred while reading the file: $e");
    }

    return null;
  }
}