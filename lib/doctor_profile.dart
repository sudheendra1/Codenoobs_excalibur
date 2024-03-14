import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pharmcare/Doctor.dart';
import 'package:pharmcare/chat_page.dart';

class Doctor_profile extends StatelessWidget {
  const Doctor_profile(
      {super.key,
      required this.url,
      required this.uid,
      required this.doc_name,
      required this.pat_name});

  final url;
  final uid;
  final doc_name;
  final pat_name;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => Doctor(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title:  Text(doc_name),
          backgroundColor: Color.fromARGB(100, 125, 216, 197),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 30, 30, 30),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(url),
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
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
                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('About:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    doc['About'],
                                    maxLines: 4,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Text('Experience:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    doc['experience'],
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
                                  ),
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                    child: Text(
                                  doc['degree'],
                                  maxLines: 2,
                                  overflow: TextOverflow.clip,
                                )),
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    doc['college'],
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
                                  ),
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
                                  'Other Expertize:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    doc['Other_speciality'],
                                    maxLines: 4,
                                    overflow: TextOverflow.clip,
                                  ),
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
                                  'Currently Working at:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                    child: Text(doc['Working'], maxLines: 1)),
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                    child: Text(
                                  doc['Previous_work'],
                                  maxLines: 4,
                                  overflow: TextOverflow.clip,
                                )),
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('RS ' + doc['fees'], maxLines: 1),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                chat_page(
                                                    receiveruserid: uid,
                                                    doc_name: doc_name,
                                                    pat_name: pat_name),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero));
                              },
                              child: Text('Start chat'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Color.fromARGB(100, 125, 216, 197),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      30), // Rounded corners
                                ),
                                elevation: 5, // Shadow
                              ),
                            )
                          ],
                        );
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
