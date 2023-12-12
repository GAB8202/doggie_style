import 'dart:convert';

import 'package:flutter/services.dart';

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
    return [
      profile.dogName ?? '',
      profile.dogAge ?? '',
      profile.dogBreed ?? '',
      profile.dogSize ?? '',
      profile.imageAsset1 ?? '',
      profile.imageAsset2 ?? '',
      profile.imageAsset3 ?? '',
      profile.imageAsset4 ?? '',
      profile.personalityTraits?.join(';') ?? '',
      profile.email ?? '',
      profile.password ?? '',
    ];
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
            dogName: row.length > 0 ? row[0] : '',
            dogAge: row.length > 1 ? row[1] : '',
            dogBreed: row.length > 2 ? row[2] : '',
            dogSize: row.length > 3 ? row[3] : '',
            imageAsset1: row.length > 4 ? row[4] : '',
            imageAsset2: row.length > 5 ? row[5] : '',
            imageAsset3: row.length > 6 ? row[6] : '',
            imageAsset4: row.length > 7 ? row[7] : '',
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

  //just used for debugging to reset profiles
    Future<void> clearProfileDataFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    String filePath = '$path/profile_data.csv';

    try {
      File file = File(filePath);

      if (await file.exists()) {
        await file.writeAsString('');
        print('Profile data file cleared successfully.');
      } else {
        print('File not found: $filePath');
      }
    } catch (e) {
      print('Error clearing profile data file: $e');
    }
  }
/*
read in the csv serving as a backend type simulator
 */
  Future<List<ProfileModel>> readProfilesFromCSV() async {
    String csvString = await rootBundle.loadString('assets/Profiles.csv');
    List<ProfileModel> profiles = [];

    LineSplitter.split(csvString).skip(1).forEach((line) {
      List<String> rowData = line.split(',');

      ProfileModel profile = ProfileModel(
        dogName: rowData.length > 0 ? rowData[0] : '',
        dogAge: rowData.length > 1 ? rowData[1] : '',
        dogBreed: rowData.length > 2 ? rowData[2] : '',
        dogSize: rowData.length > 3 ? rowData[3] : '',
        imageAsset1: rowData.length > 4 ? rowData[4] : '',
        imageAsset2: rowData.length > 5 ? rowData[5] : '',
        imageAsset3: rowData.length > 6 ? rowData[6] : '',
        imageAsset4: rowData.length > 7 ? rowData[7] : '',
        personalityTraits: rowData.sublist(8),
      );


      profiles.add(profile);
    });

    return profiles;
  }
//helper functions for organizing
   double calculateSimilarity(ProfileModel dog1, ProfileModel dog2) {
    const double personalityWeight = 0.5;
    const double sizeWeight = 0.3;
    const double ageWeight = 0.2;
    const double breedWeight = 0.1;
    final sizeCategories = {
      'Extra Small': 0,
      'Small': 1,
      'Medium': 2,
      'Large': 3,
      'Extra Large': 4,
    };
    double personalityScore = 0.0;
    if (dog1.personalityTraits != null && dog2.personalityTraits != null) {
      for (String trait in dog1.personalityTraits!) {
        if (dog2.personalityTraits!.contains(trait)) {
          personalityScore += 1;
        }
      }
      if (dog1.personalityTraits!.isNotEmpty) {
        personalityScore /= dog1.personalityTraits!.length;
      }
    }

    double sizeScore = 0.0;
    if (dog1.dogSize != null && dog2.dogSize != null &&
        dog1.dogSize!.isNotEmpty && dog2.dogSize!.isNotEmpty) {
      int sizeIndex1 = sizeCategories[dog1.dogSize!] ?? -1;
      int sizeIndex2 = sizeCategories[dog2.dogSize!] ?? -1;
      if (sizeIndex1 != -1 && sizeIndex2 != -1) {
        int sizeDifference = (sizeIndex1 - sizeIndex2).abs();
        sizeScore = 1 - (sizeDifference / 4);
        sizeScore = sizeScore.clamp(0.0, 1.0);
      }
    }

    double ageScore = 0.0;
    if (dog1.dogAge != null &&
        dog2.dogAge != null &&
        dog1.dogAge!.isNotEmpty &&
        dog2.dogAge!.isNotEmpty) {
      int? age1 = int.tryParse(dog1.dogAge!);
      int? age2 = int.tryParse(dog2.dogAge!);

      if (age1 != null && age2 != null) {
        double ageDifference = (age1 - age2).abs().toDouble();
        ageScore = 1 - (ageDifference / 10);
        ageScore = ageScore.clamp(0.0, 1.0);
      }
    }


    double breedScore = dog1.dogBreed != null && dog2.dogBreed != null &&dog1.dogBreed!.isNotEmpty && dog2.dogBreed!.isNotEmpty && dog1.dogBreed == dog2.dogBreed ? 1 : 0;

    double similarityScore = (personalityScore * personalityWeight) +
        (sizeScore * sizeWeight) +
        (ageScore * ageWeight) +
        (breedScore * breedWeight);

    return similarityScore;
  }

  /*
  reorders the profiles based on the set profile characteristics, personality traits being most important
  then size, then age, then breed
   */
  Future<List<ProfileModel>> sortProfilesBySimilarity(ProfileModel dog1, List<ProfileModel> profiles) async {
    return await Future<List<ProfileModel>>(() {
      profiles.sort((a, b) {
        double similarityA = calculateSimilarity(dog1, a);
        double similarityB = calculateSimilarity(dog1, b);
        return similarityB.compareTo(similarityA);
      });
      return profiles;
    });
  }
  /*
  removes an image from the selected
   */
  void clearImage(int imageNumber) {
    switch (imageNumber) {
      case 1:
        _profile.imageAsset1 = null;
        break;
      case 2:
        _profile.imageAsset2 = null;
        break;
      case 3:
        _profile.imageAsset3 = null;
        break;
      case 4:
        _profile.imageAsset4 = null;
        break;
      default:
        break;
    }
    onProfileUpdated?.call();
  }

}
