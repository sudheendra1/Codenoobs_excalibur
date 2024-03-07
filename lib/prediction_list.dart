import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmcare/home_page.dart';
import 'package:pharmcare/prev_diagnose.dart';

class Pred_list extends StatefulWidget{
  const Pred_list({super.key,required this.snap});
  final snap;

  @override
  State<Pred_list> createState() => _Pred_listState();
}

class _Pred_listState extends State<Pred_list> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async { Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Homepage(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero)); return true; },
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => Prev_diagnose(predict: widget.snap['disease'], prec: widget.snap['precaution'], desc: widget.snap['description'], doc: widget.snap['specialist'])
              ));
        },
        child: Card(

          color: Color.fromARGB(100, 125, 216, 197),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child:
              Center(child: Text(widget.snap['disease'],overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: 'Tommy',fontSize: 18),))

          ),
        ),
      ),
    );
  }
}