import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmcare/Diagnosis.dart';
import 'package:pharmcare/F_item.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pharmcare/First_aid_database.dart';
import 'package:pharmcare/home_page.dart';
import 'package:pharmcare/profile.dart';

class firstaidlist extends StatefulWidget{
  const firstaidlist({super.key});

  @override
  State<StatefulWidget> createState() {
    return _firstaidliststate();
  }

}

class _firstaidliststate extends State<firstaidlist>{
  @override
  Widget build(BuildContext context) {
   return DefaultTabController(
     length: 2,
     child: Scaffold(
       appBar: AppBar(
         backgroundColor: Color.fromARGB(100, 125, 216, 197),
           title: Text('First Aids'),
       bottom: TabBar(tabs: [Tab(text: 'View',),Tab(text: 'Saved',)]),),
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
     ),body: TabBarView(
     children: [StreamBuilder(
       stream:FirebaseFirestore.instance
           .collection('First_Aids').snapshots(),

       builder: (context,
           AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
         if (snapshot.connectionState == ConnectionState.waiting) {
           return const Center(
             child: CircularProgressIndicator(),
           );
         }
         return ListView.builder(
             itemCount: snapshot.data!.docs.length,
             itemBuilder: (context, index) => Faiditem(snap: snapshot.data!.docs[index].data(),));
       },
     ),

       StreamBuilder(
         stream: _firstAidStream(),

         builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
             return const Center(
               child: CircularProgressIndicator(),
             );
           }
           else if(snapshot.hasError){
             return Text('Error: ${snapshot.error}');
           }
           else{
             List<Map<String, dynamic>> firstAidData = snapshot.data ?? [];
             return ListView.builder(
                 itemCount: firstAidData.length,
                 itemBuilder: (context, index) => Faiditem(snap: firstAidData[index],));
           }

         },
       ),


     ], ),),
   );
  }

  Stream<List<Map<String, dynamic>>> _firstAidStream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (_) async {
      return await FirstAidDatabase.retrieveAllFirstAid();
    }).asyncMap((event) => event);
  }
}