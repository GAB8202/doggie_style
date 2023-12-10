import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class ProfileModel {
  String? dogName;
  String? dogAge;
  String? dogBreed;
  String? dogSize;
  String? imageAsset1;
  String? imageAsset2;
  String? imageAsset3;
  String? imageAsset4;
  List<String>? personalityTraits;
  String? email;
  String? password;

  ProfileModel({this.dogName, this.dogAge, this.dogBreed, this.dogSize, this.imageAsset1, this.imageAsset2, this.imageAsset3,this.imageAsset4, this.personalityTraits = const [], this.email, this.password});

}

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
  if (dog1.dogAge != null && dog2.dogAge != null &&
      dog1.dogAge!.isNotEmpty && dog2.dogAge!.isNotEmpty) {
    int age1 = int.tryParse(dog1.dogAge!) ?? 0;
    int age2 = int.tryParse(dog2.dogAge!) ?? 0;
    if (age1 != 0 && age2 != 0) {
      double ageDifference = (age1 - age2).abs() as double;
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

List<ProfileModel> sortProfilesBySimilarity(ProfileModel dog1, List<ProfileModel> profiles) {
  print("in sort");
  profiles.sort((a, b) {
    double similarityA = calculateSimilarity(dog1, a);
    double similarityB = calculateSimilarity(dog1, b);
    return similarityB.compareTo(similarityA);
  });
  return profiles;
}