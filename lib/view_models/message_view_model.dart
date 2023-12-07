import '../models/message_model.dart';

class MessageViewModel {
  List<Message> _messages;
  List<Message> _filteredMessages;

  MessageViewModel(List<Message> messages)
      : _messages = messages,
        _filteredMessages = List.from(messages);

  List<Message> get filteredMessages => _filteredMessages;

  void filterMessages(String query) {
    if (query.isEmpty) {
      _filteredMessages = List.from(_messages);
    } else {
      _filteredMessages = _messages
          .where((message) => message.email2.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}