import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class chatbubble extends StatelessWidget{
  const chatbubble({super.key,required this.message,required this.isSender});
  final message;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    bool isImageUrl(String message) {
      return message.startsWith('http://') || message.startsWith('https://');
    }

    return Container(
      padding:const EdgeInsets.all(12) ,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomLeft: isSender ? Radius.circular(8) : Radius.circular(0),
              bottomRight: isSender ? Radius.circular(0) : Radius.circular(8)
          ),
        color: isSender ? Colors.blue : Color.fromARGB(100, 125, 216, 197)
      ),
       child: isImageUrl(message) ?
       Image.network(message, fit: BoxFit.cover) :  // Display the image if it's an URL
       Text(
         message,
         style: TextStyle(fontSize: 16, color: Color.fromARGB(100, 0, 0, 0)),
       ),

    );
  }

}