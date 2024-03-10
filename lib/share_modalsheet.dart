import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmcare/pick_image.dart';
import 'package:pharmcare/sharing.dart';

class sharemodalsheet extends StatefulWidget {
  const sharemodalsheet(
      {super.key,
      required this.title,
      required this.img_url,
      required this.pdf_url});

  final title;
  final img_url;
  final pdf_url;

  @override
  State<StatefulWidget> createState() {
    return _sharemodalsheetstate();
  }
}

class _sharemodalsheetstate extends State<sharemodalsheet> {
  final Share_records _share_records = Share_records();

  void share(String recieverID, String docname, String patname) async {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('SHARE WITH'),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            height: 400,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chat_rooms')
                    .where('IDS',
                        arrayContains: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasError) {
                    return Text('error' + snapshot.error.toString());
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return snapshot=={}?Text('Start chat with doctor to share'):ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return ListTile(
                          title: Text(data['doctor_name']),
                          onTap: () async {
                            await _share_records.sharerecord(
                                data['IDS'][1],
                                widget.title,
                                data['doctor_name'],
                                data['patient_name'],
                                data['patient_name'],
                                widget.pdf_url,
                                widget.img_url);
                            showSnackbar('Share Successfully', context);
                            Navigator.of(context).pop();
                          },
                        );
                      });
                }),
          ),
        ),
      ],
    );
  }
}
