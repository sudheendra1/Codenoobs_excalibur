import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
const uuid=Uuid();
class Record_model {
  final FirebaseFirestore _firestore= FirebaseFirestore.instance;

  Future<String>Upload({
    required String title,
    required String image,
    required String pdfurl,
  })

  async{
    final userid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(userid).get();
    final username = (snap.data() as Map<String,dynamic>)['username'];
    String postid= Uuid().v1();
    String res = 'some error occured';
    try{
      if(title.isNotEmpty&&image.isNotEmpty|| title.isNotEmpty&&pdfurl.isNotEmpty){
        await _firestore.collection('Medical_records').doc(userid).collection('records').doc(postid).set({
          'username': username,
          'Title': title,
          'Uid': userid,
          'image_url': image,
          'pdf_url': pdfurl,
          'record_id': postid,

        });
        res ='success';
      }
    }
    catch(err){
      res=err.toString();
    }
    return res;
  }

}