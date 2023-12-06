import 'package:flutter/material.dart';
import '../models/message_model.dart';

class InsideMessageView extends StatefulWidget {
  final String email1;
  final String email2;
  final List<MessageEntry> messages;

  InsideMessageView({Key? key, required this.email1, required this.email2, required this.messages}) : super(key: key);

  @override
  _InsideMessageViewState createState() => _InsideMessageViewState();
}

class _InsideMessageViewState extends State<InsideMessageView> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversation with ${widget.email2}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.messages.length,
              itemBuilder: (context, index) {
                var message = widget.messages[index];
                bool isEmail1 = message.senderEmail == widget.email1;

                return Align(
                  alignment: isEmail1 ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color: isEmail1 ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(message.messageContent),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(labelText: 'Type your message here'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      var newMessage = MessageEntry(
                        widget.email1,
                        _messageController.text.trim(),
                      );
                      setState(() {
                        widget.messages.add(newMessage);
                      });
                      _messageController.clear();
                   }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}