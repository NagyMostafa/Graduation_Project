import 'package:cloud_firestore/cloud_firestore.dart';

class MessageInformation{
  final String senderId;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  MessageInformation({
    this.senderId,
    this.receiverId,
    this.message,
    this.timestamp,
  });

  factory MessageInformation.fromDocument(DocumentSnapshot doc) {
    return MessageInformation(
      senderId: doc['senderId'],
      receiverId: doc['receiverId'],
      message: doc['message'],
      timestamp: doc['timestamp'],
    );
  }

}