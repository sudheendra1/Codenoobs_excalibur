


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:pharmcare/First_aid.dart';

import 'package:pharmcare/home_page.dart';

class Faiditem extends StatefulWidget {
  Faiditem({super.key, required this.snap});

  final snap;


  @override
  State<Faiditem> createState() => _FaiditemState();
}
class _FaiditemState extends State<Faiditem> {



@override
      Widget build(BuildContext context) {
  return WillPopScope(
   onWillPop: () async { Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Homepage(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero)); return true; },
    child: GestureDetector(
    onTap: () {
     Navigator.pushReplacement(
          context,
           MaterialPageRoute(
              builder: (_) => First_aid(info: widget.snap["info"],url: widget.snap["url"],steps: widget.snap["steps"], fname:widget.snap["name"])
            ));
             },
              child: Card(

                color: Color.fromARGB(100, 125, 216, 197),
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                           child:
                         Center(child: Text(widget.snap['name'],overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: 'Tommy',fontSize: 18),))

                        ),
                     ),
                 ),
              );
}
}