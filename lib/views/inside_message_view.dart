import 'package:flutter/material.dart';
import 'package:navigation/models/profile_model.dart';
import 'package:navigation/views/home_view.dart';
import 'package:navigation/views/message_view.dart';
import 'package:navigation/views/profile_view.dart';
import '../models/message_model.dart';
import '../view_models/profile_view_model.dart';

class InsideMessageView extends StatefulWidget {
  final ProfileModel? profile;
  final String email1;
  final String email2;
  final List<MessageEntry> messages;
  final List<ProfileModel> matchedProfiles;
  final ProfileViewModel viewModel;

  InsideMessageView({Key? key, required this.email1, required this.email2, required this.messages, required this.profile, required this.matchedProfiles, required this.viewModel,}) : super(key: key);

  @override
  _InsideMessageViewState createState() => _InsideMessageViewState();
}
// the inside of the message
class _InsideMessageViewState extends State<InsideMessageView> {
  final TextEditingController _messageController = TextEditingController();
  late final ProfileViewModel _viewModel = widget.viewModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0x64c3e7fd).withOpacity(1),
        title: Text('Conversation with ${widget.email2}'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePreviewView(profile: widget.profile, matchedProfiles: widget.matchedProfiles, viewModel: widget.viewModel,),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: widget.profile != null && widget.profile!.imageAsset1 != null
                  ? ClipOval(
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(widget.profile!.imageAsset1!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
                  : ClipOval(
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/DSLogoPaw_white.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true, //scrolling from the bottom
              itemCount: widget.messages.length,
              itemBuilder: (context, index) {
                var message = widget.messages[index];
                bool isEmail1 = message.senderEmail == widget.email1;

                return Align(
                  alignment: isEmail1 ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      color: isEmail1 ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isEmail1 ? 20 : 5),
                        topRight: Radius.circular(isEmail1 ? 5 : 20),
                        bottomLeft: const Radius.circular(20),
                        bottomRight: const Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      message.messageContent,
                      style: const TextStyle(fontSize: 25),
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Type your message here',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                      labelStyle: const TextStyle(fontSize: 25),
                      hintStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      var newMessage = MessageEntry(
                        widget.email1,
                        _messageController.text.trim(),
                      );
                      setState(() {
                        widget.messages.insert(0, newMessage); //insert at the beginning for reverse scrolling
                      });
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


//displaying the profile, similar to in home view
class ProfilePreviewView extends StatefulWidget {
  final ProfileModel? profile;
  List<ProfileModel> matchedProfiles;
  final ProfileViewModel viewModel;

  ProfilePreviewView({Key? key, required this.profile, required this.matchedProfiles,  required this.viewModel,}) : super(key: key);

  @override
  _ProfilePreviewViewState createState() => _ProfilePreviewViewState();
}

class _ProfilePreviewViewState extends State<ProfilePreviewView> {
  int currentImageIndex = 0;
  late final ProfileViewModel _viewModel = widget.viewModel;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0x64c3e7fd).withOpacity(1),
        title: Text('${widget.profile?.dogName}s profile'),
      ),
      body: Card(
        margin: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: _imagePreview(),
              ),
              if (widget.profile?.dogName != null && widget.profile!.dogName != "Not set" && widget.profile!.dogName!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Dog Name:',
                      style: const TextStyle(fontFamily: 'Indie Flower', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      children: [
                        TextSpan(
                          text: '  ${widget.profile?.dogName}',
                          style: const TextStyle(fontFamily: 'Oswald', fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),


              if (widget.profile?.dogAge != null && widget.profile!.dogAge != "Not set" && widget.profile!.dogAge!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Dog Age:',
                      style: const TextStyle(fontFamily: 'Indie Flower', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      children: [
                        TextSpan(
                          text: '  ${widget.profile?.dogAge}',
                          style: const TextStyle(fontFamily: 'Oswald', fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),

              if (widget.profile?.dogBreed != null && widget.profile!.dogBreed != "Not set" && widget.profile!.dogBreed!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Dog Breed:',
                      style: const TextStyle(fontFamily: 'Indie Flower', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      children: [
                        TextSpan(
                          text: '  ${widget.profile?.dogBreed}',
                          style: const TextStyle(fontFamily: 'Oswald', fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),

              if (widget.profile?.dogSize != null && widget.profile!.dogSize != "Not set" && widget.profile!.dogSize!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Dog Size:',
                      style: const TextStyle(fontFamily: 'Indie Flower', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      children: [
                        TextSpan(
                          text: '  ${widget.profile?.dogSize}',
                          style: const TextStyle(fontFamily: 'Oswald', fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),




               if (widget.profile?.personalityTraits != null && widget.profile!.personalityTraits!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, top: 12.0, bottom: 75),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Personality Traits:",
                          style: TextStyle(fontFamily: 'Indie Flower', fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Wrap(
                              direction: Axis.horizontal,
                              children: [
                                Text(
                                  widget.profile!.personalityTraits!.join(',  '),
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
      )
    );

  }
  //handles image functionality
  Widget _imagePreview() {
    List<String?> selectedImages = [
      widget.profile?.imageAsset1,
      widget.profile?.imageAsset2,
      widget.profile?.imageAsset3,
      widget.profile?.imageAsset4,
    ].where((image) => image != null && image != 'null').toList();

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
            image: selectedImages[currentImageIndex] != null
                ? AssetImage(selectedImages[currentImageIndex]!)
                : const AssetImage('assets/images/DSLogo_white.png'),
            fit: selectedImages[currentImageIndex] == 'assets/images/DSLogo_white.png'
                ? BoxFit.fitWidth
                : BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
