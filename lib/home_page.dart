import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pharmcare/Doctor.dart';
import 'package:pharmcare/Medicines_info.dart';
import 'package:pharmcare/Search.dart';
import 'package:pharmcare/barcode_scan.dart';
import 'package:pharmcare/firstaid_data.dart';
import 'package:pharmcare/profile.dart';
import 'package:pharmcare/Diagnosis.dart';
import 'package:pharmcare/Firstaid_list.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _homepagestate();
  }
}

class _homepagestate extends State<Homepage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool yourBooleanValue=false;

  final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;
  int _currentindex=0;
  String? Scanresult;

  late StreamSubscription subscription;
  var isdeviceconnected=false;
  bool isalertset= false;

  Future scanbarcode()async{

    try{
      Scanresult= await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.BARCODE);
    } on PlatformException{
      Scanresult= 'Failed to get platform version';
    }
    if(!mounted) return;
    setState(() {
      Scanresult=Scanresult;
      Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Bar(bar:Scanresult),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero));

      if (kDebugMode) {
        print(Scanresult);
      }
    });
  }
  FocusNode _focusNode = FocusNode();
  @override
  void dispose() {
    subscription.cancel();
    _focusNode.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    getConnectivity();
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

  getConnectivity(){
    subscription=Connectivity().onConnectivityChanged.listen((result) async {
      isdeviceconnected = await InternetConnectionChecker().hasConnection;
      if(!isdeviceconnected && isalertset==false){
        showdialogbox();
        setState(() {
          isalertset=true;
        });

      }
    },);
  }

  showdialogbox(){
    showDialog<bool>(context: context, builder: (context){
      return AlertDialog(
        title: const Text('NO CONNECTION'),
        content: const Text('Please check your internet connection'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context, false);
              setState(() {
                isalertset=false;

              });
              isdeviceconnected=await InternetConnectionChecker().hasConnection;
              if(!isdeviceconnected){
                showdialogbox();
                setState(() {
                  isalertset=true;
                });
              }
            },
            child: const Text('OK', style: TextStyle(color: Colors.black),),
          ),

        ],
      );
    },
    );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Exit'),
              content: const Text('Are you sure you want to exit the app?'),
              actions: [
                TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
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
        return shouldPop!;
      },
      child: Scaffold(
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
          appBar: AppBar(
              backgroundColor: Color.fromARGB(100, 125, 216, 197),

              actions: [
                Container(
                  width: 300,
                  child: TextButton.icon(
                    onPressed: () {
    Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>SearchPage(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero));},
                    icon: Icon(Icons.search, color: Colors.black),
                    label: Text('Search medicines', style: TextStyle(color: Colors.black)),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      side: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: scanbarcode,
                  icon: Icon(Icons.barcode_reader),
                ),
              ]),
          body: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>medicineslist()));},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Container(
                      height: 100,
                      width: 390,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0), // Rounded corners
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      child: Row(

                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                            child: Image.asset(
                              "assets/images/Medicines.png",
                              height: 50,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Most searched medicines',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                Text("Details about medicines")
                              ],
                            ),
                          ),
                          /*Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                            child: ElevatedButton(
                              child: Text("See All"),
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                foregroundColor: Colors.black,
                                backgroundColor: Color.fromARGB(100, 125, 216, 197),
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Doctor()));},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Container(
                      height: 100,
                      width: 390,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0), // Rounded corners
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      child: Row(

                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                            child: yourBooleanValue?Image.asset("assets/images/Patient.png",height: 50,):Image.asset(
                              "assets/images/Doc.png",
                              height: 50,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                yourBooleanValue?Text('View patients',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)):Text('Consult Doctor',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                                yourBooleanValue?Text('Chat with your patients'):Text("Advice from virtual doctor")
                              ],
                            ),
                          ),
                          /*Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                            child: ElevatedButton(
                              child: Text("Visit"),
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                foregroundColor: Colors.black,
                                backgroundColor: Color.fromARGB(100, 125, 216, 197),
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>firstaidlist()));},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Container(
                      height: 100,
                      width: 390,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0), // Rounded corners
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      child: Row(

                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                            child: Image.asset(
                              "assets/images/First_aid.png",
                              height: 50,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('First Aids',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                                Text("First aid tips for problems")
                              ],
                            ),
                          ),
                          /*Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                            child: ElevatedButton(
                              child: Text("Get"),
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                foregroundColor: Colors.black,
                                backgroundColor: Color.fromARGB(100, 125, 216, 197),
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Container(
                    width: 390,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(100, 125, 216, 197),
                      borderRadius: BorderRadius.circular(12.0), // Rounded corners
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Faiddata(fname: "CPR")));},
                                child: Container(
                                  height: 110,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(100, 125, 216, 197),
                                    borderRadius: BorderRadius.circular(12.0),
                                    // Rounded corners
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/CPR.png",
                                        height: 85,
                                        width: 110,
                                      ),
                                      Text(('CPR'))
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Faiddata(fname: "Cuts & Grazes")));},
                                child: Container(
                                  height: 110,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(100, 125, 216, 197),
                                    borderRadius: BorderRadius.circular(12.0),
                                    // Rounded corners
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/Cuts&Grazes.png",
                                        height: 85,
                                        width: 110,
                                      ),
                                      Text(('Cuts & Grazes'))
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Faiddata(fname: "Burns")));},
                                child: Container(
                                  height: 110,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(100, 125, 216, 197),
                                    borderRadius: BorderRadius.circular(12.0),
                                    // Rounded corners
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/Burn.png",
                                        height: 85,
                                        width: 110,
                                      ),
                                      Text(('Burns'))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Faiddata(fname: "Bee Stings")));},
                                child: Container(
                                  height: 110,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(100, 125, 216, 197),
                                    borderRadius: BorderRadius.circular(12.0),
                                    // Rounded corners
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/Bee_sting.png",
                                        height: 85,
                                        width: 110,
                                      ),
                                      Text(('Bee Stings'))
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Faiddata(fname: "Sprains")));},
                                child: Container(
                                  height: 110,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(100, 125, 216, 197),
                                    borderRadius: BorderRadius.circular(12.0),
                                    // Rounded corners
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/Sprain.png",
                                        height: 85,
                                        width: 110,
                                      ),
                                      Text(('Sprains'))
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Faiddata(fname: "Leech Attacks")));},
                                child: Container(
                                  height: 110,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(100, 125, 216, 197),
                                    borderRadius: BorderRadius.circular(12.0),
                                    // Rounded corners
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/Leech.png",
                                        height: 85,
                                        width: 110,
                                      ),
                                      Text(('Leech attacks'))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Faiddata(fname: "Splinters")));},
                                child: Container(
                                  height: 110,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(100, 125, 216, 197),
                                    borderRadius: BorderRadius.circular(12.0),
                                    // Rounded corners
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/Splinters.png",
                                        height: 85,
                                        width: 110,
                                      ),
                                      Text(('Splinter'))
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Faiddata(fname: "Animal Bites")));},
                                child: Container(
                                  height: 110,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(100, 125, 216, 197),
                                    borderRadius: BorderRadius.circular(12.0),
                                    // Rounded corners
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/Animal_bites.png",
                                        height: 85,
                                        width: 110,
                                      ),
                                      Text(('Animal Bites'))
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Faiddata(fname: "Nosebleeds")));},
                                child: Container(
                                  height: 110,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(100, 125, 216, 197),
                                    borderRadius: BorderRadius.circular(12.0),
                                    // Rounded corners
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/Nosebleeds.png",
                                        height: 85,
                                        width: 110,
                                      ),
                                      Text(('Nosebleeds'))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
