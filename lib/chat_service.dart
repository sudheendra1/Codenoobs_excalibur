import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:pharmcare/message_model.dart';

class chatservice extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore= FirebaseFirestore.instance;
  Future<void> sendmessage(String recieverId,String message,String Docname,String patname,String username,String reply,String imageurl)async{
    final String currentuserId= _firebaseAuth.currentUser!.uid;
    final String currentuseremail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();


    Message newMessage = Message(senderId: currentuserId  , recieverId: recieverId, message: message, timestamp: timestamp,username: username,replyTo: reply, imageurl: imageurl);

    List<String> ids = [currentuserId,recieverId];
    ids.sort();
    String chatroomId= ids.join("_");

    await _firebaseFirestore.collection('chat_rooms').doc(chatroomId).collection('messages').add(newMessage.toMap());

    final CollectionReference collection = FirebaseFirestore.instance.collection('chat_rooms');



      DocumentReference docRef = collection.doc(chatroomId);
      DocumentSnapshot docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {

        await docRef.set({'IDS': [currentuserId,recieverId],'doctor_name':Docname, 'patient_name': patname});
      } else {
        Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
        if (data != null && !data.containsKey('IDS')) {

          await docRef.update({'IDS': [currentuserId,recieverId]});
        }
        if (data != null && !data.containsKey('doctor_name')) {

          await docRef.update({'doctor_name':Docname});
        }
        if (data != null && !data.containsKey('patient_name')) {

          await docRef.update({'patient_name': patname});
        }
      }



    //await _firebaseFirestore.collection('chat_rooms').doc(chatroomId).set({'IDS': [currentuserId,recieverId]});
  }
  Stream<QuerySnapshot> getMessages(String userId,String OtheruserId){
    List<String> ids= [userId,OtheruserId];
    ids.sort();
    String chatroomId= ids.join("_");
    return _firebaseFirestore.collection('chat_rooms').doc(chatroomId).collection('messages').orderBy('timestamp',descending: false).snapshots();
  }
}