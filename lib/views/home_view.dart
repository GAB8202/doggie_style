
import 'package:flutter/material.dart';
import 'package:navigation/models/profile_model.dart';
import 'package:navigation/views/message_view.dart';
import 'profile_view.dart';
import 'dart:async';

List<ProfileModel> matchedProfiles=[];
int currentProfileIndex = 0;
int timerLength = 1;
class HomeView extends StatefulWidget {
  final String title;

  HomeView({Key? key, this.title = "Doggie Style"}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}
class _HomeViewState extends State<HomeView> {


  Color screenBackgroundColor = Colors.transparent; // Track background color
  bool isRemovingProfile = false;
  bool isAddingProfile = false;
  List<ProfileModel> profiles=[];
  @override
  void initState() {
    super.initState();
    initializeProfiles();
  }

  Future<void> initializeProfiles() async {
    List<ProfileModel> profileList = await readProfilesFromCSV();
    setState(() {
      profiles = profileList;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Or any other loading indicator
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.person, color: Colors.white.withOpacity(1)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileView()),
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
        backgroundColor:  Color(0x64c3e7fd).withOpacity(1),
        actions: [
          IconButton(
            icon: Icon(Icons.mail_rounded, color: Colors.white.withOpacity(1)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MessageView()),
              );
            },
          ),
        ],
      ),
      body: GestureDetector(

        child: Container(
          color: screenBackgroundColor,
          child: Stack(
            children: [
              if (currentProfileIndex < profiles.length)
                ProfileSwipeView(
                  profiles: profiles,
                  removeCurrentProfileCallback: removeCurrentProfile,
                  addCurrentProfileCallback: addCurrentProfile,
                  isRemovingProfile: isRemovingProfile,
                  setScreenState: setScreenState,
                ),
              if (currentProfileIndex == profiles.length)
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/DSlogo_blue.png',
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                              'No more profiles to show!',
                              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold,),
                              textAlign: TextAlign.center
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                child: GestureDetector(
                  onTap: () {
                    if (!isRemovingProfile) {
                      // Change background color to red for 3 seconds when thumbs down button is clicked
                      setState(() {
                        screenBackgroundColor = Colors.red;
                      });

                      Timer(Duration(seconds: timerLength), () {
                        // Reset background color after 3 seconds
                        setState(() {
                          screenBackgroundColor = Colors.transparent;
                          isRemovingProfile = true;
                          removeCurrentProfile(); // Remove the profile after 3 seconds
                        });
                      });
                    }
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
                    if (!isAddingProfile) {
                      // Change background color to green for 2 seconds when thumbs up button is clicked
                      setState(() {
                        screenBackgroundColor = Colors.green;
                      });

                      Timer(Duration(seconds: timerLength), () {
                        // Reset background color after 2 seconds
                        setState(() {
                          screenBackgroundColor = Colors.transparent;
                          isAddingProfile = true;
                          addCurrentProfile(); // Add the profile after 2 seconds
                        });
                      });
                    }
                  },
                  child: Container(
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(100.0),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void removeCurrentProfile() {
    setState(() {
      profiles.removeAt(currentProfileIndex);
      if (currentProfileIndex == profiles.length-1){
        currentProfileIndex++;
      }
      isRemovingProfile = false;
      print(currentProfileIndex);
      print('Removed');
    });
  }
  void addCurrentProfile(){
    matchedProfiles.add(profiles.elementAt(currentProfileIndex));
    //removeCurrentProfile();
    printMatchedProfilesNames();
    print(currentProfileIndex);
    print('Added');

    setState(() {
      profiles.removeAt(currentProfileIndex);
      if (currentProfileIndex == profiles.length-1){
        currentProfileIndex++;
      }
      isAddingProfile = false;
      print(currentProfileIndex);

    });

  }
  void printMatchedProfilesNames() {
    for (ProfileModel profile in matchedProfiles) {
      print(profile.dogName);
    }
  }
  void setScreenState(bool removingProfile) {
    setState(() {
      isRemovingProfile = removingProfile;
    });
  }

}

class ProfileSwipeView extends StatelessWidget {
  final List<ProfileModel> profiles;
  final Function removeCurrentProfileCallback;
  final Function addCurrentProfileCallback;
  final bool isRemovingProfile;
  final Function setScreenState;

  const ProfileSwipeView({
    required this.profiles,
    required this.removeCurrentProfileCallback,
    required this.addCurrentProfileCallback,
    required this.isRemovingProfile,
    required this.setScreenState,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: profiles.length,
      itemBuilder: (BuildContext context, int index) {
        currentProfileIndex = index;

        return Dismissible(
          key: Key(profiles[index].dogName!), // Provide a unique key for each profile
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart && !isRemovingProfile) {
              // Swiped left
              setScreenState(true);
              removeCurrentProfileCallback();
            } else if (direction == DismissDirection.startToEnd) {
              // Swiped right
              addCurrentProfileCallback();
            }
          },

          background: Container(
            color: Colors.red, // Color for thumbs down
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Icon(
                  Icons.thumb_down,
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
            ),
          ),
          secondaryBackground: Container(
            color: Colors.green, // Color for thumbs up
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Icon(
                  Icons.thumb_up,
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: ProfileCard(profile: profiles[index]),
          ),
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
            if (profile.dogName != "Not set" &&  profile.dogName!.isNotEmpty)
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
            if (profile.dogAge != "Not set" &&  profile.dogAge!.isNotEmpty)
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
            if (profile.dogBreed != "Not set"&&  profile.dogBreed!.isNotEmpty )
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
            if (profile.dogSize != "Not set" &&  profile.dogSize!.isNotEmpty)
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
            if (profile.personalityTraits.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 12.0, bottom: 75), // Adjust left padding as needed
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Personality Traits:",
                      style: TextStyle(fontFamily: 'Indie Flower', fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    if (profile.personalityTraits.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0), // Adjust left padding as needed
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Text(
                              profile.personalityTraits.join(',  '),
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
  List<String> selectedImages = [];

  @override
  void initState() {
    super.initState();
    initializeSelectedImages();
  }

  void initializeSelectedImages() {
    selectedImages = [
      widget.profile.imageAsset1 ?? '',
      widget.profile.imageAsset2 ?? '',
      widget.profile.imageAsset3 ?? '',
      widget.profile.imageAsset4 ?? '',
    ].where((image) => image.isNotEmpty).toList();

    if (selectedImages.isEmpty) {
      selectedImages.add('assets/images/DSlogo_blue.png');
    }
  }
  @override
  Widget build(BuildContext context) {

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



