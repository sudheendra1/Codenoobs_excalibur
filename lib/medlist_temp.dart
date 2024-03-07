import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pharmcare/med_view.dart';

class medtemp extends StatefulWidget{
  const medtemp({super.key,required this.medicine});
final medicine;
  @override
  State<StatefulWidget> createState() {
    return _medtempstate();
  }

}

class _medtempstate extends State<medtemp>{
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => medview(pn: widget.medicine['product_name'],sc: widget.medicine['salt_composition'],pm: widget.medicine['product_manufactured'],md: widget.medicine['medicine_desc'],se: widget.medicine['side_effects'],)));},
      child: Card(
        child: Center(
          heightFactor: 3,
          child: Text(widget.medicine['product_name'],style: TextStyle(fontFamily: 'Tommy'),),
        ),
      ),
    );
  }

}