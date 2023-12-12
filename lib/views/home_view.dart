import 'dart:math';
import 'package:flutter/material.dart';
import 'package:navigation/models/profile_model.dart';
import '../views/message_view.dart';
import 'profile_view.dart';
import '../view_models/profile_view_model.dart';
import 'dart:async'; // Import for Timer

List<ProfileModel> likedProfiles=[];
List<ProfileModel> dislikedProfiles=[];
List<ProfileModel> matchedProfiles=[];
int currentProfileIndex = 0;
int timerLength = 1;
bool match=false;
class HomeView extends StatefulWidget {
  final String title;
  final ProfileViewModel viewModel;

  HomeView({Key? key, this.title = "Doggie Style", required this.viewModel}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}
class _HomeViewState extends State<HomeView> {
  late final ProfileViewModel _viewModel = widget.viewModel;


  Color screenBackgroundColor = Colors.transparent; // Track background color
  bool isRemovingProfile = false;
  bool isAddingProfile = false;

  bool showMatchedNotification = false;
  String matchedDogName = '';
  List<ProfileModel> profiles=[];
  @override
  void initState() {
    super.initState();
    initializeProfiles();
  }
  // reads in and organizes profiles
  Future<void> initializeProfiles() async {
    List<ProfileModel> profileList = await _viewModel.readProfilesFromCSV();
    List<ProfileModel> profileList2=await _viewModel.sortProfilesBySimilarity(_viewModel.profile, profileList);
    setState(() {
      print("comparing");
      profiles = profileList2;
    });
  }
  void showMatchNotification(String dogName) {
    setState(() {
      showMatchedNotification = true;
      matchedDogName= dogName;
    });

    //keeps for 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        showMatchedNotification = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    //just incase list is not showing
    if (profiles.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
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
        backgroundColor:  const Color(0x64c3e7fd).withOpacity(1),
        actions: [
          IconButton(
            icon: Icon(Icons.mail_rounded, color: Colors.white.withOpacity(1)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MessageView(viewModel: _viewModel, matchedProfiles: matchedProfiles,)),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GestureDetector(

            child: Container(
              color: screenBackgroundColor,
              child: Stack(
                children: [
                  //are profiles to swipe on
                  if (currentProfileIndex < profiles.length)
                    ProfileSwipeView(
                      profiles: profiles,
                      removeCurrentProfileCallback: removeCurrentProfile,
                      addCurrentProfileCallback: addCurrentProfile,
                      isRemovingProfile: isRemovingProfile,
                      setScreenState: setScreenState,
                      homeViewState: this,
                    ),
                  //when out of profiles to swipe on
                  if (currentProfileIndex == profiles.length)
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/DSLogo_blue.png',
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
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
                          setState(() {
                            screenBackgroundColor = Colors.red;
                          });

                          Timer(Duration(seconds: timerLength), () {
                            setState(() {
                              screenBackgroundColor = Colors.transparent;
                              isRemovingProfile = true;
                              removeCurrentProfile();
                            });
                          });
                        }
                      },
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(100.0),
                          ),
                          color: Colors.red,
                        ),
                        child: const Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 25.0, bottom: 25.0),
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
                          Random random = Random();
                          int randomNumber = random.nextInt(2) + 1;

                          if (randomNumber == 2) {//random number for 50/50 chance of matching
                            matchedProfiles.add(profiles.elementAt(currentProfileIndex));
                            //printLikedProfilesNames();
                            print(currentProfileIndex);
                            print('Added to matchedProfiles');
                            match=true;
                            showMatchNotification(profiles.elementAt(currentProfileIndex).dogName!);

                          }

                          //green background animation
                          setState(() {
                            screenBackgroundColor = Colors.green;
                          });

                          Timer(Duration(seconds: timerLength), () {
                            setState(() {
                              screenBackgroundColor = Colors.transparent;
                              isAddingProfile = true;
                              addCurrentProfile();
                            });
                          });
                        }
                      },
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100.0),
                          ),
                          color: Colors.green,
                        ),
                        child: const Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 25.0, bottom: 25.0),
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
            ),
          ),
          //pop up for matching
          if (showMatchedNotification)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.green, // Customize the color of the notification bar
                height: 50, // Set the height of the notification bar
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MessageView(viewModel: _viewModel, matchedProfiles: matchedProfiles,)),
                      );

                    },
                    child: Text(
                      'You matched with $matchedDogName!! Tap to chat',
                      style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 25),

                    ),
                  ),
                ),
              ),
            ),
        ],
      )

    );
  }
// means they did not like
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
  //means they did like
  void addCurrentProfile(){
    likedProfiles.add(profiles.elementAt(currentProfileIndex));
    //removeCurrentProfile();
    printlikedProfilesNames();
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


//debugging use
  void printlikedProfilesNames() {
    for (ProfileModel profile in likedProfiles) {
      print(profile.dogName);
    }
  }
  //for animations liking or not liking
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
  final _HomeViewState homeViewState;

  const ProfileSwipeView({
    required this.profiles,
    required this.removeCurrentProfileCallback,
    required this.addCurrentProfileCallback,
    required this.isRemovingProfile,
    required this.setScreenState,
    required this.homeViewState,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: profiles.length,
      itemBuilder: (BuildContext context, int index) {
        currentProfileIndex = index;
        //allows for swipe action
        return Dismissible(
          key: Key(profiles[index].dogName!), // Provide a unique key for each profile
          onDismissed: (direction) {

            if (direction == DismissDirection.endToStart && !isRemovingProfile) {
              // Swiped left
              Random random = Random();
              int randomNumber = random.nextInt(2) + 1;

              if (randomNumber == 2) {
                matchedProfiles.add(profiles.elementAt(index));
                print(index);
                print('Added to matchedProfiles');
                match = true;
                homeViewState.showMatchNotification(profiles.elementAt(index).dogName!);
              }
              setScreenState(true);
              removeCurrentProfileCallback();
            } else if (direction == DismissDirection.startToEnd) {
              // Swiped right
              addCurrentProfileCallback();
            }
          },
          //  the like dislike buttons
          background: Container(
            color: Colors.red,
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Icon(
                  Icons.thumb_down,
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
            ),
          ),
          secondaryBackground: Container(
            color: Colors.green,
            child: const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 20.0),
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
  //card makeup, mimiced also in the preview view to give similar look
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20.0),
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
                padding: const EdgeInsets.only(left: 25.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Dog Name:',
                    style: const TextStyle(fontFamily: 'Indie Flower', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    children: [
                      TextSpan(
                        text: '  ${profile.dogName}',
                        style: const TextStyle(fontFamily: 'Oswald', fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            if (profile.dogAge != "Not set" &&  profile.dogAge!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Dog Age:',
                    style: const TextStyle(fontFamily: 'Indie Flower', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    children: [
                      TextSpan(
                        text: '  ${profile.dogAge}',
                        style: const TextStyle(fontFamily: 'Oswald', fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            if (profile.dogBreed != "Not set"&&  profile.dogBreed!.isNotEmpty )
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Dog Breed:',
                    style: const TextStyle(fontFamily: 'Indie Flower', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    children: [
                      TextSpan(
                        text: '  ${profile.dogBreed}',
                        style: const TextStyle(fontFamily: 'Oswald', fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            if (profile.dogSize != "Not set" &&  profile.dogSize!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Dog Size:',
                    style: const TextStyle(fontFamily: 'Indie Flower', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    children: [
                      TextSpan(
                        text: '  ${profile.dogSize}',
                        style: const TextStyle(fontFamily: 'Oswald', fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            if (profile.personalityTraits!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 12.0, bottom: 75),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Personality Traits:",
                      style: TextStyle(fontFamily: 'Indie Flower', fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    if (profile.personalityTraits!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Text(
                              profile.personalityTraits!.join(',  '),
                              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
//handles the images inside the larger cards as they also have the tap functionality
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
      selectedImages.add('assets/images/DSLogo_blue.png');
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