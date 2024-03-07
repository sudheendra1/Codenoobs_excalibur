import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmcare/doctors_view.dart';
import 'package:pharmcare/home_page.dart';
import 'package:uuid/uuid.dart';



class diagnose_result extends StatefulWidget{
  const diagnose_result({super.key,required this.prediction,required this.description,required this.precaution, required this.doctor});
  final precaution;
  final prediction;
  final description;
  final doctor;

  @override
  State<diagnose_result> createState() => _diagnose_resultState();
}

class _diagnose_resultState extends State<diagnose_result> {
  var uuid = Uuid().v4();
  void _record()async{
final snapshot= await FirebaseFirestore.instance.collection('Predictions').doc(FirebaseAuth.instance.currentUser!.uid).collection('Predictions').where('disease',isEqualTo:widget.prediction ).get();
if(snapshot.docs.isEmpty){
await FirebaseFirestore.instance.collection('Predictions').doc(FirebaseAuth.instance.currentUser!.uid).collection('Predictions').doc(uuid).set({
  'disease': widget.prediction,
  'description': widget.description,
  'precaution': widget.precaution,
  'specialist': widget.doctor,
  'uuid': uuid,

});
ScaffoldMessenger.of(context).clearSnackBars();
ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  content: Text("Data recorded successfully"),
));
}
else{
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("Data already exists"),
  ));
}
  }

  @override
  Widget build(BuildContext context) {
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
      child: Scaffold(appBar: AppBar(backgroundColor: Color.fromARGB(100, 125, 216, 197),
        title: Text('Diagnosis result'),),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [Text("Disclaimer: This prediction is not supposed to be considered 100% accurate. Don't just follow this prediction, Please also consult a doctor",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
        SizedBox(height: 20,),
        Row(
          children: [
            Text("Prediction: ",style: TextStyle(fontWeight: FontWeight.bold),),
            Text(widget.prediction)
          ],
        ),
          SizedBox(height: 20,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Description: ",style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(child: Text(widget.description))
            ],
          ),
          SizedBox(height: 20,),
          Text('Precautions: ',style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 20,),
          Row(
            children: [
              Text("precaution 1: ",style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.precaution["Symptom_precaution_0"]??""),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Text("precaution 2: ",style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.precaution["Symptom_precaution_1"]??""),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Text("precaution 3: ",style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.precaution["Symptom_precaution_2"]??""),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Text("precaution 4: ",style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.precaution["Symptom_precaution_3"]??""),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Text('Doctor to Consult: ',style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.doctor)
            ],
          ),
          SizedBox(height: 20,),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color.fromARGB(100, 125, 216, 197),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  elevation: 5, // Shadow
                ),
                onPressed: (){Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>doctors_view(snap: widget.doctor,),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero));},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Text('View specialists to consult'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Center(child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Color.fromARGB(100, 125, 216, 197),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
                elevation: 5, // Shadow
              ),
              onPressed: _record,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text('Record Prediction'),
                ],
              ),
            ),)

        ],),
      ),
      ),
    );
  }
}