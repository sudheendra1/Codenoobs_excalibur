import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmcare/home_page.dart';
import 'package:pharmcare/record_viewer.dart';
import 'package:pharmcare/upload_records.dart';

class Record extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _recordstate();
  }
}

class _recordstate extends State<Record> {

  void _addoverlay() {
    showModalBottomSheet(

        context: context,
        builder: (ctx) => upload_records());
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    Homepage(),
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
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Medical_records').doc(FirebaseAuth.instance.currentUser!.uid).collection('records').snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            else{
              return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 0.75,),
              itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index){
                  final document = snapshot.data!.docs[index];
                  final data = document.data() as Map<String, dynamic>;
                  final title = data['Title'];
                  final img_url=data['image_url'];
                  final pdf_url= data['pdf_url'];
                  return Container(
                    margin: const EdgeInsets.all(8),
                    color: Color.fromARGB(100, 125, 216, 197),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                      GestureDetector(
                          onTap: (){Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (context, animation1, animation2) =>
                                      PDF(pdf_url: pdf_url, img_url: img_url),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero));},
                          child: img_url==''?Text(title):Image.network(img_url,height: 150,width: 150,fit: BoxFit.cover,)),
                      Text(title),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        IconButton(onPressed: (){}, icon: Icon(Icons.share))
                      ],)
                    ],));

                },

              );
            }

          }
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(100, 125, 216, 197),
          onPressed: _addoverlay,
          child: const Icon(Icons.upload),
        ),
      ),
    );
  }
}