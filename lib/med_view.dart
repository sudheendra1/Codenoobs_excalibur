import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class medview extends StatelessWidget{
  const medview({super.key,required this.pn,required this.sc,required this.pm,required this.md,required this.se});
final pn;
  final sc;
  final pm;
  final md;
  final se;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(elevation: 0.0, title: Text(pn),

      backgroundColor: Color.fromARGB(
          100, 125, 216, 197),),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 8,right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Text("Medicine name: "+pn,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
            SizedBox(height: 10,),
            Container(decoration:BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Color.fromARGB(130,100,204,197)
            ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                  child: Text(sc,style: TextStyle(fontSize: 14),),
                )),
            SizedBox(height: 20,),
            Text("Manufactured by: "+pm),
            SizedBox(height: 20,),
            Text("Medicine info:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
            SizedBox(height: 10,),
             Text(md),
            SizedBox(height: 20,),
            Container(
              width: 390,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Color.fromARGB(100, 125, 216, 197),
                 // Rounded corners
                
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8,bottom: 8),
                child: Column(

                  children: [
                    SizedBox(height: 10,),
                    Text("Side effects:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,fontFamily: 'Tommy')),
                    SizedBox(height: 10,),
                    Text(se,style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),

            ),

                ],
        ),
      ),
    ),);
  }

}