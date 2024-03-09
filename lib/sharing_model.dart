import 'package:cloud_firestore/cloud_firestore.dart';

class Sharing {
  final String senderId;
  final String username;
  final String recieverId;
  final String title;
  final String imageurl;
  final String pdfurl;

  Sharing({required this.senderId,required this.recieverId,required this.title,required this.username,required this.imageurl,required this.pdfurl,});

  Map<String,dynamic> toMap(){
    return{
      'SenderId': senderId,
      'SenderName': username,
      'RecieverId': recieverId,
      'title': title,
      'imageUrl': imageurl,
      'pdfurl': pdfurl,
    };
  }

}