import 'package:flutter/material.dart';
import 'package:navigation/models/profile_model.dart';
import '../views/home_view.dart';
import '../view_models/profile_view_model.dart';
import '../views/inside_message_view.dart';
import '../models/message_model.dart'; 
import '../view_models/message_view_model.dart';


List<Message> messageList =[];
class MessageView extends StatefulWidget {
  final String title;
  final ProfileViewModel viewModel;
  final List<ProfileModel> matchedProfiles;


  const MessageView({Key? key, this.title = "Doggie Style", required this.viewModel,required this.matchedProfiles}) : super(key: key);

  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  late MessageViewModel _messageViewModel;
  late ProfileViewModel _viewModel = widget.viewModel;
  @override
  @override
  void initState() {
    super.initState();
    _initializeData();
  }
//populates the list of messages
  void _initializeData() {
    messageList = [];
    int lastMessage = widget.matchedProfiles.length;
    if(_viewModel.profile.email=='robertbob@gmail.com'){
      presentationMatchesFill();
    } //just used for the demo

    String getDogName(ProfileModel profile) {
      lastMessage--;
      return profile.dogName ?? 'No Name';
    }
    //fills with the matches and default hello
    for (int x = widget.matchedProfiles.length - 1; x >= 0; x--) {
      Message m1;
      if (lastMessage > 0) {
        String otherUser = getDogName(widget.matchedProfiles[x]);

        m1 = Message(
          email1: 'user1@example.com',
          email2: otherUser,
          messageEntries: [
            MessageEntry(otherUser, 'Hello!'),
          ],
          profile: widget.matchedProfiles[x],
        );

        messageList.add(m1);
      }
    }

    _messageViewModel = MessageViewModel(messageList);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Transform.scale(
          scale: 2,
          child: IconButton(
            icon: Image.asset('assets/images/DSLogoPaw_white.png'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeView(viewModel: widget.viewModel)),
              );
            },
          ),
        ),
        backgroundColor: const Color(0x64c3e7fd).withOpacity(1),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Messages',
                labelStyle: TextStyle(fontSize: 25),
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                _messageViewModel.filterMessages(value);
                setState(() {});
              },
            ),
          ),
          Expanded(

            child: ListView.builder(
              itemCount: _messageViewModel.filteredMessages.length,
              itemBuilder: (BuildContext context, int index) {
                var message = _messageViewModel.filteredMessages[index];
                return SizedBox(
                  height: 80.0,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 0.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: const Color(0x64c3e7fd).withOpacity(1),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InsideMessageView(
                                email1: message.email1,
                                email2: message.email2,
                                messages: message.messageEntries,
                                profile: message.profile,
                                matchedProfiles: matchedProfiles,
                                viewModel: widget.viewModel,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: message.profile != null && message.profile!.imageAsset1 != null
                                  ? ClipOval(
                                child: Container(
                                  width: 75,
                                  height: 75,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(message.profile!.imageAsset1!),
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

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                message.email2,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }

  //for demo
  void presentationMatchesFill(){
    ProfileModel Harper = ProfileModel(
      dogName: 'Harper',
      dogSize: 'Small',
      dogAge: '11',
      dogBreed: 'Havanese',
      imageAsset1: 'assets/images/Havanese/dog10.jpg',
        imageAsset2: 'assets/images/Havanese/dog11.jpg',
        imageAsset3: 'assets/images/Havanese/dog12.jpg'

    );
    Message m1=Message(
      email1: 'user1@example.com',
      email2: 'Harper',
      messageEntries: [
        MessageEntry('Harper', 'Perfect, see you then!'),
        MessageEntry('user1@example.com', 'Want to meet at Schenley Park?'),
        MessageEntry('user1@example.com', 'Lets do Saturday then.'),
        MessageEntry('Harper', 'I can either do Saturday at 2 or Sunday at 12.'),
        MessageEntry('user1@example.com', 'What day and time work best for you?'),
        MessageEntry('user1@example.com', 'That sounds like a great idea!'),
        MessageEntry('Harper', 'Do you want to set up a playdate for them?'),
        MessageEntry('Harper', 'Our dogs seem very compatible'),
        MessageEntry('user1@example.com', 'Thank you so much!'),
        MessageEntry('user1@example.com', 'Hi!'),
        MessageEntry('Harper', 'Your dog is so cute!'),
        MessageEntry('Harper', 'Hello!'),

      ],
      profile: Harper,
    );
    if(messageList.contains(m1)){

    }
    else{
      messageList.add(m1);
    }

  }

}
