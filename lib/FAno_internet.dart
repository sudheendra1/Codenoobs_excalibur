import 'package:flutter/material.dart';
import 'package:pharmcare/F_item.dart';
import 'package:pharmcare/First_aid_database.dart';

class FANI extends StatelessWidget{

  Stream<List<Map<String, dynamic>>> _firstAidStream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (_) async {
      return await FirstAidDatabase.retrieveAllFirstAid();
    }).asyncMap((event) => event);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async { return false; },
      child: Scaffold(
        body: StreamBuilder(
          stream: _firstAidStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Map<String, dynamic>> firstAidData = snapshot.data ?? [];
              return ListView.builder(
                  itemCount: firstAidData.length,
                  itemBuilder: (context, index) => Faiditem(
                    snap: firstAidData[index], saved: true,
                  ));
            }
          },
        ),
      ),
    );
  }

}