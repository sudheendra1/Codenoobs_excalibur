import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:pharmcare/sharing_model.dart';

class Share_records extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore= FirebaseFirestore.instance;
  Future<void> sharerecord(String recieverId,String title,String Docname,String patname,String username,String pdfurl,String imageurl)async{
    final String currentuserId= _firebaseAuth.currentUser!.uid;


    Sharing newShare = Sharing(senderId: currentuserId, recieverId: recieverId, title: title, username: username, imageurl: imageurl, pdfurl: pdfurl);

    List<String> ids = [currentuserId,recieverId];
    ids.sort();
    String shareroomId= ids.join("_");

    await _firebaseFirestore.collection('share_rooms').doc(shareroomId).collection('records').add(newShare.toMap());

    final CollectionReference collection = FirebaseFirestore.instance.collection('share_rooms');



    DocumentReference docRef = collection.doc(shareroomId);
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




  }

}