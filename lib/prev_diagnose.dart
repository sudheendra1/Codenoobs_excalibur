import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmcare/Diagnosis.dart';

class Prev_diagnose extends StatelessWidget{
  const Prev_diagnose({super.key,required this.predict,required this.prec,required this.desc, required this.doc});
  final predict;
  final prec;
  final desc;
  final doc;
  @override
  Widget build(BuildContext context) {
   return WillPopScope(
     onWillPop: () async {
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Chatbot()));
       return true;
     },
     child: Scaffold(appBar: AppBar(backgroundColor: Color.fromARGB(100, 125, 216, 197),
       title: Text(predict),),

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
               Text(predict)
             ],
           ),
           SizedBox(height: 20,),
           Row(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text("Description: ",style: TextStyle(fontWeight: FontWeight.bold)),
               Expanded(child: Text(desc))
             ],
           ),
           SizedBox(height: 20,),
           Text('Precautions: ',style: TextStyle(fontWeight: FontWeight.bold)),
           SizedBox(height: 20,),
           Row(
             children: [
               Text("precaution 1: ",style: TextStyle(fontWeight: FontWeight.bold)),
               Text(prec["Symptom_precaution_0"]??""),
             ],
           ),
           SizedBox(height: 20,),
           Row(
             children: [
               Text("precaution 2: ",style: TextStyle(fontWeight: FontWeight.bold)),
               Text(prec["Symptom_precaution_1"]??""),
             ],
           ),
           SizedBox(height: 20,),
           Row(
             children: [
               Text("precaution 3: ",style: TextStyle(fontWeight: FontWeight.bold)),
               Text(prec["Symptom_precaution_2"]??""),
             ],
           ),
           SizedBox(height: 20,),
           Row(
             children: [
               Text("precaution 4: ",style: TextStyle(fontWeight: FontWeight.bold)),
               Text(prec["Symptom_precaution_3"]??""),
             ],
           ),
           SizedBox(height: 20,),
           Row(
             children: [
               Text('Doctor to Consult: ',style: TextStyle(fontWeight: FontWeight.bold)),
               Text(doc)
             ],
           ),

         ],),
     ),),
   );
  }

}