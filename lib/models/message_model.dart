
import 'package:navigation/models/profile_model.dart';

class Message {
  final String email1;
  final String email2;
  final List<MessageEntry> messageEntries;
  final ProfileModel? profile;
  Message({required this.email1, required this.email2, required this.messageEntries, this.profile});

}

class MessageEntry {
  final String senderEmail;
  final String messageContent;

  MessageEntry(this.senderEmail, this.messageContent);
}