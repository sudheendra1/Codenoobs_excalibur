import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:pharmcare/First_aid.dart';
import 'package:pharmcare/Diagnosis.dart';
import 'package:pharmcare/home_page.dart';
import 'package:pharmcare/profile.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Faiddata extends StatefulWidget {
  const Faiddata({super.key, required this.fname});

  final fname;


  @override
  State<StatefulWidget> createState() {
    return _Faiddatastate();
  }

}

class _Faiddatastate extends State<Faiddata> {
  int _currentindex=0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async { Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Homepage(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero)); return true; },
      child: Scaffold(
        appBar: AppBar(elevation: 0.0, title: Text(widget.fname),

        backgroundColor: Color.fromARGB(
            100, 125, 216, 197),),
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
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('First_Aids')
              .doc(widget.fname)
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
              return First_aid(info: doc["info"],url: doc["url"],steps: doc["steps"], fname:widget.fname);
            }
          }
        ),),
    );
    }

}