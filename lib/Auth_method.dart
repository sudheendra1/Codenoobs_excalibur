

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Auth_method{
  final  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String>signup({
    required String username,
    required String emailid,
    required String password,
    required bool Doctor,



  })
  async{
    String res = "some error occured";
    try{
      if(emailid.isNotEmpty||password.isNotEmpty||username.isNotEmpty){
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: emailid, password: password);

        await _firestore.collection('users').doc(cred.user!.uid).set({
          'username': username,
          'email_id': emailid,
          'Uid': cred.user!.uid,
          'image_url': '',
          'Allergies': '',
          'DOB': '',
          'Diseases': '',
          'is_doctor': Doctor


        });
        res = 'success';
      }
    }
    catch(err){
      res=err.toString();

    }
    return res;

  }
}