import 'package:flutter/material.dart';
import 'package:navigation/models/profile_model.dart';
import '../views/message_view.dart';
import 'profile_view.dart';
import '../view_models/profile_view_model.dart';


class HomeView extends StatefulWidget {
  // Pass the title as a parameter if needed, or just hardcode it inside the widget
  final String title;
  final ProfileViewModel viewModel;

  HomeView({Key? key, this.title = "Doggie Style", required this.viewModel}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}
class _HomeViewState extends State<HomeView> {
  late ProfileViewModel _viewModel = widget.viewModel;
  int currentProfileIndex = 0;
  List<ProfileModel> profiles = [
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
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.person, color: Colors.white.withOpacity(1)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileView(viewModel: _viewModel,)),
            );
          },
        ),
        centerTitle: true,
        title: Transform.scale(
          scale: 2,
          child: IconButton(
            icon: Image.asset('assets/images/DSLogoPaw_white.png'),
            onPressed: () {},
          ),
        ),
        backgroundColor: Color(0xc3e7fdff).withOpacity(.5),
        actions: [
          IconButton(
            icon: Icon(Icons.mail_rounded, color: Colors.white.withOpacity(1)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MessageView(viewModel: _viewModel)),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ProfileSwipeView(profiles: profiles),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            child: GestureDetector(
              onTap: () {
                removeCurrentProfile();

              },
              child: Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(100.0),
                  ),
                  color: Colors.red,
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
                    child: Icon(
                      Icons.thumb_down,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: GestureDetector(
              onTap: () {
              },
              child: Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100.0),
                    //bottomLeft: Radius.circular(10.0),
                  ),
                  color: Colors.green,
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25.0, bottom: 25.0),
                    child: Icon(
                      Icons.thumb_up,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

    );

  }
  void removeCurrentProfile() {
    setState(() {
      profiles.removeAt(currentProfileIndex);
      if (currentProfileIndex < profiles.length) {
        // If there are more profiles, move to the next one
        currentProfileIndex++;
      }
    });
  }

}

class ProfileSwipeView extends StatelessWidget {
  final List<ProfileModel> profiles;

  const ProfileSwipeView({required this.profiles});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: profiles.length,
      itemBuilder: (BuildContext context, int index) {
        return SingleChildScrollView(
          child: ProfileCard(profile: profiles[index]),
        );
      },
    );
  }
}

class ProfileCard extends StatelessWidget {
  final ProfileModel profile;

  const ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: ProfileImagePreview(profile: profile),
            ),
            if (profile.dogName != "Not set")
              Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Dog Name:',
                    style: TextStyle(fontFamily: 'Indie Flower', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    children: [
                      TextSpan(
                        text: '  ${profile.dogName}',
                        style: TextStyle(fontFamily: 'Oswald', fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            if (profile.dogAge != "Not set")
              Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Dog Age:',
                    style: TextStyle(fontFamily: 'Indie Flower', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    children: [
                      TextSpan(
                        text: '  ${profile.dogAge}',
                        style: TextStyle(fontFamily: 'Oswald', fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            if (profile.dogBreed != "Not set")
              Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Dog Breed:',
                    style: TextStyle(fontFamily: 'Indie Flower', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    children: [
                      TextSpan(
                        text: '  ${profile.dogBreed}',
                        style: TextStyle(fontFamily: 'Oswald', fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            if (profile.dogSize != "Not set")
              Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Dog Size:',
                    style: TextStyle(fontFamily: 'Indie Flower', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    children: [
                      TextSpan(
                        text: '  ${profile.dogSize}',
                        style: TextStyle(fontFamily: 'Oswald', fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            if (profile.personalityTraits!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 12.0, bottom: 75), // Adjust left padding as needed
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Personality Traits:",
                      style: TextStyle(fontFamily: 'Indie Flower', fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    if (profile.personalityTraits!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0), // Adjust left padding as needed
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Text(
                              profile.personalityTraits!.join(',  '),
                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ProfileImagePreview extends StatefulWidget {
  final ProfileModel profile;

  const ProfileImagePreview({required this.profile});

  @override
  _ProfileImagePreviewState createState() => _ProfileImagePreviewState();
}

class _ProfileImagePreviewState extends State<ProfileImagePreview> {
  int currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String?> selectedImages = [
      widget.profile.imageAsset1,
      widget.profile.imageAsset2,
      widget.profile.imageAsset3,
      widget.profile.imageAsset4,
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

        height: 450,
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[300],
          image: DecorationImage(
            image: AssetImage(selectedImages[currentImageIndex]!),
            fit: selectedImages[currentImageIndex] == 'assets/images/DSLogo_white.png'
                ? BoxFit.fitWidth
                : BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

