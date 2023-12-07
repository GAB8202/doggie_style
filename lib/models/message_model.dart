import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class Message {
  final String email1;
  final String email2;
  final List<MessageEntry> messageEntries;

  Message({required this.email1, required this.email2, required this.messageEntries});

}

class MessageEntry {
  final String senderEmail;
  final String messageContent;

  MessageEntry(this.senderEmail, this.messageContent);
}