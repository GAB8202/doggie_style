import 'package:flutter/material.dart';
import '../views/home_view.dart';
import '../view_models/profile_view_model.dart';
import '../views/inside_message_view.dart';
import '../models/message_model.dart'; 
import '../view_models/message_view_model.dart'; 

class MessageView extends StatefulWidget {
  final String title;
  final ProfileViewModel viewModel;

  MessageView({Key? key, this.title = "Doggie Style", required this.viewModel}) : super(key: key);

  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  late MessageViewModel _messageViewModel;

  @override
  void initState() {
    super.initState();
    var messages = [
      Message(email1: 'user1@example.com', email2: 'Terry', messageEntries: [
        MessageEntry('Terry', 'Hello!'),
      ]),
      Message(email1: 'user1@example.com', email2: 'Max', messageEntries: [
        MessageEntry('user1@example.com', 'Your dog is very cute!'),
        MessageEntry('Max', 'Thanks so much! Yours too!')
      ]),
    ];
    _messageViewModel = MessageViewModel(messages);
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
        backgroundColor: Color(0x64c3e7fd).withOpacity(1),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Messages',
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
                return Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InsideMessageView(
                            email1: message.email1,
                            email2: message.email2,
                            messages: message.messageEntries,
                          ),
                        ),
                      );
                    },
                    child: Text(message.email2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
