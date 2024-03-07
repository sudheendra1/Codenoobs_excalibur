import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmcare/chat_page.dart';

class doctors_view extends StatefulWidget{
  const doctors_view({super.key,required this.snap});
  final snap;

  @override
  State<StatefulWidget> createState() {
    return _doctorviewstate();
  }

}

class _doctorviewstate extends State<doctors_view>{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? patient;
  final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    _firestore.collection("users").doc(_firebaseAuth.currentUser!.uid).get().then((value){
      setState(() {
        patient=value.data()?['username'];

      });
    });

  }
  @override
  Widget build(BuildContext context) {
    CollectionReference doctors = FirebaseFirestore.instance.collection('Doctors').doc(widget.snap).collection('doctors_list');
    return Scaffold(body:  StreamBuilder<QuerySnapshot>(

      stream: doctors.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No doctors available."));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              return ListTile(
                onTap: (){Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>chat_page( receiveruserid: doc['UID'],doc_name:doc['Name'],pat_name:patient),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero));
    },
                title: Text(doc['Name']),
                subtitle: Text('${doc['Degree']}, ${doc['Experience']} experience'),
              );
            },
          ),
        );
      },
    ),);
  }

}