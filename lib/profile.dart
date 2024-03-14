import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmcare/Diagnosis.dart';
import 'package:pharmcare/doctor_details.dart';
import 'package:pharmcare/home_page.dart';
import 'package:pharmcare/login_page.dart';
import 'package:pharmcare/image_picker.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pharmcare/personel_details.dart';
import 'package:pharmcare/records.dart';

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
  bool yourBooleanValue = false;
  String speciality = "";
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    _firestore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        yourBooleanValue = value.data()?['is_doctor'];
        if (yourBooleanValue) {
          speciality = value.data()?["Speciality"];
        }

        print(yourBooleanValue);
      });
    });
  }

  Future<void> deleteUserFromFirestore() async {
    String uid = _firebaseAuth.currentUser!.uid;

    await _firestore.collection('users').doc(uid).delete();
    if (yourBooleanValue) {
      await _firestore
          .collection('Doctors')
          .doc(speciality)
          .collection('doctors_list')
          .doc(uid)
          .delete();
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
    await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => const Loginpage()), (route) => false);
  }

  void signout() async {
    //await GoogleSignIn().disconnect();
    await FirebaseAuth.instance.signOut();

    await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => const Loginpage()), (route) => false);
  }

  Uint8List? _selectedimage;
  int _currentindex = 3;

  @override
  Widget build(BuildContext context) {
    //fetchData();
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => Homepage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: const Text('Profile'),
          backgroundColor: Color.fromARGB(100, 125, 216, 197),
        ),
        bottomNavigationBar: Container(
          color: Color.fromARGB(100, 125, 216, 197),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 4),
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
                              Record(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero));
                }
                if (index == 3) {
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
              tabBackgroundColor: Color.fromARGB(200, 125, 216, 197),
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
                  icon: Icons.medical_information,
                  text: 'Records',
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
        body: SingleChildScrollView(
          child: Container(
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
                    TaskSnapshot snap =
                        await storageref.putData(_selectedimage!);
                    String imageurl = await snap.ref.getDownloadURL();

                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .update({'image_url': imageurl});
                    FirebaseFirestore.instance
                        .collection('Doctors')
                        .doc(speciality)
                        .collection('doctors_list')
                        .doc(user.uid)
                        .update({'img_url': imageurl});
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      Map<String, dynamic> doc =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return !yourBooleanValue
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    const Text('USERNAME:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      doc['username'],
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Date of Birth:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                        child: Text(
                                      doc['DOB'],
                                      maxLines: 4,
                                      overflow: TextOverflow.clip,
                                    )),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const Text('Email-Id:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      doc['email_id'],
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const Text('Gender:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      doc['gender'],
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const Text('Allergies:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      doc['Allergies'],
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Diseases:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(doc['Diseases'], maxLines: 1),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    const Text('About:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      doc['About'],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const Text('USERNAME:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      doc['username'],
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Date of Birth:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                        child: Text(
                                      doc['DOB'],
                                      maxLines: 4,
                                      overflow: TextOverflow.clip,
                                    )),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const Text('Email-Id:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      doc['email_id'],
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const Text('Gender:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      doc['gender'],
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const Text('Experience:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      doc['experience'],
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Degree:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(doc['degree'], maxLines: 1),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Medical College:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(doc['college'], maxLines: 1),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Other Expertize:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(doc['Other_speciality']),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Currently Working at:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(doc['Working'], maxLines: 1),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Previous Work Experience:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(doc['Previous_work']),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Fees:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(doc['fees'], maxLines: 1),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            );
                    }
                  },
                ),
                TextButton(
                    onPressed: () {
                      !yourBooleanValue
                          ? Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          personel(),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero))
                          : Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          Dpersonel(),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero));
                    },
                    child: const Text(
                      'Update or add details',
                      style: TextStyle(
                        color: Color.fromARGB(255, 125, 216, 197),
                      ),
                    )),
                TextButton(
                    onPressed: () {
                      signout();
                      // Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Color.fromARGB(255, 125, 216, 197),
                      ),
                    )),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(100, 125, 216, 197),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                      ),
                      elevation: 5, // Shadow
                    ),
                    onPressed: () async {
                      final shouldPop = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete account'),
                            content: const Text(
                                'Are you sure you want to delete your account?'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  try {
                                    await deleteAccount();
                                    final snackBar = SnackBar(
                                      content:
                                          Text('Acoount successfully deleted'),
                                      duration: Duration(seconds: 3),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                            pageBuilder: (context, animation1,
                                                    animation2) =>
                                                Loginpage(),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration:
                                                Duration.zero));
                                  } catch (e) {
                                    print("Error deleting account: $e");
                                  }
                                },
                                child: const Text(
                                  'Yes',
                                  style: TextStyle(color: Colors.red),
                                ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
