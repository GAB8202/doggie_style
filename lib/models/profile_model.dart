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

 /* List<ProfileModel> profilesData = [
    ProfileModel(
      dogName: 'Buddy',
      dogAge: '3',
      dogBreed: 'Golden Retriever',
      dogSize: 'Large',
      imageAsset1: 'assets/profile_pics/dog1.jpg',
      imageAsset2: 'assets/profile_pics/dog2.jpg',
      imageAsset3: 'assets/profile_pics/dog3.jpg',
      imageAsset4: 'assets/profile_pics/dog5.jpg',
      personalityTraits: ['Friendly', 'Playful', 'Calm'],
    ),
    ProfileModel(
      dogName: 'Daisy',
      dogAge: '2',
      dogBreed: 'Beagle',
      dogSize: 'Medium',
      imageAsset1: 'assets/profile_pics/dog6.jpg',
      imageAsset2: 'assets/profile_pics/dog7.jpg',
      imageAsset3: 'assets/profile_pics/dog8.jpg',
      imageAsset4: 'assets/profile_pics/dog9.jpg',
      personalityTraits: ['Energetic', 'Friendly', 'Kid Friendly'],
    ),
    ProfileModel(
      dogName: 'Rocky',
      dogAge: '4',
      dogBreed: 'Siberian Husky',
      dogSize: 'Large',
      imageAsset1: 'assets/profile_pics/dog13.jpg',
      imageAsset2: 'assets/profile_pics/dog14.jpg',
      imageAsset3: 'assets/profile_pics/dog15.jpg',
      imageAsset4: 'assets/profile_pics/dog16.jpg',
      personalityTraits: ['Curious', 'Independent', 'Playful'],
    ),
    ProfileModel(
      dogName: 'Luna',
      dogAge: '1',
      dogBreed: 'Labrador Retriever',
      dogSize: 'Large',
      imageAsset1: 'assets/profile_pics/dog6.jpg',
      imageAsset2: 'assets/profile_pics/dog8.jpg',
      imageAsset3: 'assets/profile_pics/dog9.jpg',
      imageAsset4: 'assets/profile_pics/dog13.jpg',
      personalityTraits: ['Gentle', 'Loyal', 'Protective'],
    ),
    ProfileModel(
      dogName: 'Max',
      dogAge: '5',
      dogBreed: 'German Shepherd',
      dogSize: 'Large',
      imageAsset1: 'assets/profile_pics/dog1.jpg',
      imageAsset2: 'assets/profile_pics/dog3.jpg',
      imageAsset3: 'assets/profile_pics/dog5.jpg',
      imageAsset4: 'assets/profile_pics/dog7.jpg',
      personalityTraits: ['Energetic', 'Curious', 'Loyal'],
    ),
  ];*/
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

//just storing this here for now
/*List<ProfileModel> profiles = [
    ProfileModel(
      dogName: 'Buddy',
      dogAge: '3',
      dogBreed: 'Golden Retriever',
      dogSize: 'Large',
      imageAsset1: 'assets/profile_pics/dog1.jpg',
      imageAsset2: 'assets/profile_pics/dog2.jpg',
      imageAsset3: 'assets/profile_pics/dog3.jpg',
      imageAsset4: 'assets/profile_pics/dog5.jpg',
      personalityTraits: ['Friendly', 'Playful', 'Calm'],
    ),
    ProfileModel(
      dogName: 'Daisy',
      dogAge: '2',
      dogBreed: 'Beagle',
      dogSize: 'Medium',
      imageAsset1: 'assets/profile_pics/dog6.jpg',
      imageAsset2: 'assets/profile_pics/dog7.jpg',
      imageAsset3: 'assets/profile_pics/dog8.jpg',
      imageAsset4: 'assets/profile_pics/dog9.jpg',
      personalityTraits: ['Energetic', 'Friendly', 'Kid Friendly'],
    ),
    ProfileModel(
      dogName: 'Rocky',
      dogAge: '4',
      dogBreed: 'Siberian Husky',
      dogSize: 'Large',
      imageAsset1: 'assets/profile_pics/dog13.jpg',
      imageAsset2: 'assets/profile_pics/dog14.jpg',
      imageAsset3: 'assets/profile_pics/dog15.jpg',
      imageAsset4: 'assets/profile_pics/dog16.jpg',
      personalityTraits: ['Curious', 'Independent', 'Playful'],
    ),
    ProfileModel(
      dogName: 'Luna',
      dogAge: '1',
      dogBreed: 'Labrador Retriever',
      dogSize: 'Large',
      imageAsset1: 'assets/profile_pics/dog6.jpg',
      imageAsset2: 'assets/profile_pics/dog8.jpg',
      imageAsset3: 'assets/profile_pics/dog9.jpg',
      imageAsset4: 'assets/profile_pics/dog13.jpg',
      personalityTraits: ['Gentle', 'Loyal', 'Protective'],
    ),
    ProfileModel(
      dogName: 'Max',
      dogAge: '5',
      dogBreed: 'German Shepherd',
      dogSize: 'Large',
      imageAsset1: 'assets/profile_pics/dog1.jpg',
      imageAsset2: 'assets/profile_pics/dog3.jpg',
      imageAsset3: 'assets/profile_pics/dog5.jpg',
      imageAsset4: 'assets/profile_pics/dog7.jpg',
      personalityTraits: ['Energetic', 'Curious', 'Loyal'],
    ),
  ];*/

