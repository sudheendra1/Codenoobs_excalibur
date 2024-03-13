import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pharmcare/Diagnosis.dart';
import 'package:pharmcare/home_page.dart';
import 'package:pharmcare/profile.dart';
import 'package:pharmcare/record_viewer.dart';
import 'package:pharmcare/share_modalsheet.dart';
import 'package:pharmcare/upload_records.dart';

class Record extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _recordstate();
  }
}

class _recordstate extends State<Record> {
  void _addoverlay() {
    showModalBottomSheet(context: context, builder: (ctx) => upload_records());
  }
  int _currentindex = 2;
  @override
  Widget build(BuildContext context) {
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
          title: const Text('Records'),
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
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Medical_records')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('records')
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final document = snapshot.data!.docs[index];
                    final data = document.data() as Map<String, dynamic>;
                    final title = data['Title'];
                    final img_url = data['image_url'];
                    final pdf_url = data['pdf_url'];
                    return Container(
                        margin: const EdgeInsets.all(8),
                        color: Color.fromARGB(100, 125, 216, 197),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                          pageBuilder: (context, animation1,
                                                  animation2) =>
                                              PDF(
                                                  pdf_url: pdf_url,
                                                  img_url: img_url),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration:
                                              Duration.zero));
                                },
                                child: img_url == ''
                                    ? Image.asset(
                                        'assets/images/pdf_image.png',
                                        height: 150,
                                        width: 150,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        img_url,
                                        height: 150,
                                        width: 150,
                                        fit: BoxFit.cover,
                                      )),
                            Text(title),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (ctx) => sharemodalsheet(
                                                title: title,
                                                img_url: img_url,
                                                pdf_url: pdf_url,
                                              ));
                                    },
                                    icon: Icon(Icons.share))
                              ],
                            )
                          ],
                        ));
                  },
                );
              }
            }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(100, 125, 216, 197),
          onPressed: _addoverlay,
          child: const Icon(Icons.upload),
        ),
      ),
    );
  }
}
