import 'dart:core';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmcare/Diagnosis.dart';
import 'package:pharmcare/home_page.dart';
import 'package:pharmcare/login_page.dart';
import 'package:pharmcare/image_picker.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


var user = FirebaseAuth.instance.currentUser!;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() {
    return _profilestate();
  }
}

class _profilestate extends State<Profile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool yourBooleanValue=false;
  String speciality="";
  final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    fetchData();
  }
  fetchData() async {
    _firestore.collection("users").doc(_firebaseAuth.currentUser!.uid).get().then((value){
      setState(() {
        yourBooleanValue = value.data()?['is_doctor'];
        if(yourBooleanValue){
          speciality=value.data()?["Speciality"];
        }

        print(yourBooleanValue);
      });
    });

  }
  Future<void> deleteUserFromFirestore() async {
    String uid = _firebaseAuth.currentUser!.uid;

    
    await _firestore.collection('users').doc(uid).delete();
    if(yourBooleanValue){
      await _firestore.collection('Doctors').doc(speciality).collection('doctors_list').doc(uid).delete();
    }
  }
  Future<void> deleteUserFromAuthentication() async {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      await user.delete();
    }
  }

  Future<void> deleteAccount() async {
    await deleteUserFromFirestore();
    await deleteUserFromAuthentication();
  }

  void signout() async {

    //await GoogleSignIn().disconnect();
    await FirebaseAuth.instance.signOut();

    await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (c) => const Loginpage()),(route)=>false);
  }
  Uint8List? _selectedimage;
  int _currentindex=2;

  @override
  Widget build(BuildContext context) {
    return

      WillPopScope(
        onWillPop: () async { Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Homepage(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero)); return true; },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            title: const Text('Profile'),
            backgroundColor: Color.fromARGB(100, 125, 216, 197),
          ),
          bottomNavigationBar: Container(
            color: Color.fromARGB(100, 125, 216, 197),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 25.0, vertical: 4),
              child: GNav(
                selectedIndex: _currentindex,
                style: GnavStyle.oldSchool,
                textSize: 10,

                onTabChange: (index) {
                  if (index == 0) {
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                Homepage(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero));
                  }
                  if (index == 1) {
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                Chatbot(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero));
                  }
                  if (index == 2) {
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                Profile(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero));
                  }

                },
                //backgroundColor: Color.fromARGB(100, 125, 216, 197),
                color: Colors.black,
                activeColor: Colors.black,
                tabBorderRadius: 10,
                tabBackgroundColor:Color.fromARGB(200, 125, 216, 197),
                haptic: true,
                hoverColor: Color.fromARGB(150, 125, 216, 197),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                //tabBackgroundColor: Colors.blueGrey.shade900,

                duration: Duration(milliseconds: 900),
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                    gap: 10,
                  ),
                  GButton(
                    icon: Icons.chat_rounded,
                    text: 'Diagnose',
                    gap: 10,
                  ),

                  GButton(
                    icon: Icons.person,
                    text: 'Profile',
                    gap: 10,
                  ),

                ],
              ),
            ),
          ),

          body:
          Container(

            padding: EdgeInsets.fromLTRB(20, 30, 30, 30),
            child: Column(


              children: [
                imagepicker(
                  onpickedimage: (pickedimage) async {
                    _selectedimage = pickedimage;
                    final storageref = FirebaseStorage.instance
                        .ref()
                        .child('User-images')
                        .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');
                    TaskSnapshot snap = await storageref.putData(_selectedimage!);
                    String imageurl = await snap.ref.getDownloadURL();

                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .update({'image_url': imageurl});
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        Map<String, dynamic> doc =
                        snapshot.data!.data() as Map<String, dynamic>;
                        return Column(
                          children: [Row(children: [const Text('USERNAME:',style: TextStyle(fontWeight: FontWeight.bold)),SizedBox(width: 5,),Text(doc['username'],maxLines: 1,),],),

                            const SizedBox(
                              height: 20,
                            ),
                            Row(crossAxisAlignment: CrossAxisAlignment.start,children: [const Text('Date of Birth:',style: TextStyle(fontWeight: FontWeight.bold)),SizedBox(width: 5,),

                              Expanded(child: Text(doc['DOB'],maxLines: 4,overflow: TextOverflow.clip,)),

                            ],),

                            const SizedBox(
                              height: 20,
                            ),
                            Row(children: [const Text('Email-Id:',style: TextStyle(fontWeight: FontWeight.bold)),SizedBox(width: 5,),Text(doc['email_id'],maxLines: 1,),],),

                            const SizedBox(
                              height: 20,
                            ),
                            Row(children: [const Text('Gender:',style: TextStyle(fontWeight: FontWeight.bold)),SizedBox(width: 5,),Text(doc['gender'],maxLines: 1,),],),

                            const SizedBox(
                              height: 20,
                            ),

                            Row(children: [const Text('Allergies:',style: TextStyle(fontWeight: FontWeight.bold)),SizedBox(width: 5,),Text(doc['Allergies'],maxLines: 1,),],),



                            const SizedBox(
                              height: 20,
                            ),
                            Row(crossAxisAlignment: CrossAxisAlignment.start,children: [const Text('Diseases:',style: TextStyle(fontWeight: FontWeight.bold),),SizedBox(width: 5,), Text(doc['Diseases'],maxLines: 1),],),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),



                Expanded(
                  child: TextButton(
                      onPressed: () {
                        signout();
                        // Navigator.of(context).pop();
                      },
                      child: const Text('Logout',style: TextStyle(color: Color.fromARGB(255, 125, 216, 197),),)),
                ),

                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Color.fromARGB(100, 125, 216, 197),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Rounded corners
                      ),
                      elevation: 5, // Shadow
                    ),
                    onPressed: () async {

                      final shouldPop = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete account'),
                            content: const Text('Are you sure you want to delete your account?'),
                            actions: [
                              TextButton(
                                onPressed: () async{
                                  try{
                                    await deleteAccount();
                                    final snackBar = SnackBar(
                                      content: Text('Acoount successfully deleted'),
                                      duration: Duration(seconds: 3),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Loginpage(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero));
                                  } catch (e) {

                                    print("Error deleting account: $e");
                                  }

                                },

                                child: const Text('Yes', style: TextStyle(color: Colors.red),),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Text(
                                  'No',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Text('Delete My Account'),
                      ],
                    ),
                  ),
                ),
                /*ElevatedButton(
                  onPressed: () async {

                      final shouldPop = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete account'),
                            content: const Text('Are you sure you want to delete your account?'),
                            actions: [
                              TextButton(
                                onPressed: () async{
                                  try{
                                    await deleteAccount();
                                    final snackBar = SnackBar(
                                      content: Text('Acoount successfully deleted'),
                                      duration: Duration(seconds: 3),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Loginpage(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero));
                                  } catch (e) {

                                    print("Error deleting account: $e");
                                  }

                               },

                                child: const Text('Yes', style: TextStyle(color: Colors.red),),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Text(
                                  'No',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                      },


                  child: Text("Delete My Account"),
                )*/

              ],
            ),
          ),


        ),

      );
  }
}
