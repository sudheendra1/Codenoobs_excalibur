import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String username;
  final String recieverId;
  final String message;
  final Timestamp timestamp;
  final String imageurl;
  final String? replyTo;

  Message({required this.senderId,required this.recieverId,required this.message,required this.timestamp,required this.username,required this.imageurl,required this.replyTo,});

  Map<String,dynamic> toMap(){
    return{
      'SenderId': senderId,
      'SenderName': username,
      'RecieverId': recieverId,
      'message': message,
      'timestamp': timestamp,
      'imageUrl': imageurl,
      'replyTo': replyTo,
    };
  }

}