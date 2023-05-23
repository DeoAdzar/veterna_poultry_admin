import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  final Timestamp date;
  final String senderId,
      receiverId,
      message,
      conversationId,
      conversationName,
      conversationImage;

  const Conversation(
      {required this.conversationId,
      required this.conversationImage,
      required this.conversationName,
      required this.date,
      required this.message,
      required this.receiverId,
      required this.senderId});
}
