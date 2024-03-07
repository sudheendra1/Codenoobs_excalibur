import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmcare/Diagnosis.dart';
import 'package:pharmcare/chat_page.dart';
import 'package:pharmcare/doctors_view.dart';
import 'package:pharmcare/home_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pharmcare/profile.dart';

class Doctor extends StatefulWidget {
  const Doctor({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Doctorstate();
  }

}

class _Doctorstate extends State<Doctor> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? yourBooleanValue;

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

        print(yourBooleanValue);
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    if (yourBooleanValue == null) {
      return Center(child: CircularProgressIndicator(),);
    }
    if (yourBooleanValue!) {
      return WillPopScope(
        onWillPop:  () async {
          Navigator.push(
              context,
              PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      Homepage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero));
          return true;
        },
        child: Scaffold(body: Container(child: StreamBuilder(
          stream: _firestore.collection('chat_rooms')
              .where('IDS', arrayContains: _firebaseAuth.currentUser!.uid)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return Text('error' + snapshot.error.toString());
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return snapshot=={}?Text('No patients currently'):ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  Map<String, dynamic> data = document.data()! as Map<
                      String,
                      dynamic>;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: ListTile(title: data['patient_name']==""?Text('Patient'):Text(data['patient_name']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => chat_page(
                                receiveruserid: data['IDS'][0],
                                doc_name: data['doctor_name'],
                                pat_name: data['patient_name']),
                          ),
                        );
                      },

                    ),
                  );
                });
          },
        ),),),
      );
    }
    else {
      return
        WillPopScope(
      onWillPop:  () async {
      Navigator.push(
      context,
      PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) =>
     Homepage(),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero));
      return true;
      },
          child: DefaultTabController(
            length: 2,
            child: Scaffold(appBar: AppBar(title: Text("doctors"),
              bottom: TabBar(
                tabs: [Tab(text: 'New',), Tab(text: 'previous',)],),backgroundColor: Color.fromARGB(100, 125, 216, 197),),
              bottomNavigationBar: Container(
                color: Color.fromARGB(100, 125, 216, 197),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 4),
                  child: GNav(

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
              body: TabBarView(
                children: [StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Doctors').snapshots(),

                  builder: (context,
                      AsyncSnapshot<
                          QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = snapshot.data!.docs[index];
                          Map<String, dynamic> data = document.data()! as Map<
                              String,
                              dynamic>;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical:2),
                            child: ListTile(title: Text(data['name']),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        doctors_view(snap: data['name']),
                                  ),
                                );
                              },
                            ),
                          );
                        });
                  },
                ), Container(child: StreamBuilder(
                  stream: _firestore.collection('chat_rooms')
                      .where('IDS', arrayContains: _firebaseAuth.currentUser!.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasError) {
                      return Text('error' + snapshot.error.toString());
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = snapshot.data!.docs[index];
                          Map<String, dynamic> data = document.data()! as Map<
                              String,
                              dynamic>;
                          print(data['IDS'][0]);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: ListTile(title: Text(data['doctor_name']),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => chat_page(
                                        receiveruserid: data['IDS'][1],
                                        doc_name: data['doctor_name'],
                                        pat_name: data['patient_name']),
                                  ),
                                );
                              },

                            ),
                          );
                        });
                  },
                ),),
                ],
              ),
            ),
          ),
        );
    }
  }

}