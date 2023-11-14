class ProfileModel {
  String? dogName;
  String? dogAge;
  String? dogBreed;
  String? dogSize;
  String? imageAsset1;
  String? imageAsset2;
  String? imageAsset3;
  List<String> personalityTraits;

  ProfileModel({this.dogName, this.dogAge, this.dogBreed, this.dogSize, this.imageAsset1, this.imageAsset2, this.imageAsset3, this.personalityTraits = const []});
}