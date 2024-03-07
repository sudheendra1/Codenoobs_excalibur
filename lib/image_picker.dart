
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmcare/pick_image.dart';
import 'package:image_picker/image_picker.dart';


class imagepicker extends StatefulWidget {
  const imagepicker({super.key,required this.onpickedimage});
  final void Function(Uint8List pickedimage) onpickedimage;
  @override
  State<imagepicker> createState() {
    return _imagepickerstate();
  }
}

class _imagepickerstate extends State<imagepicker> {

  String? Url;
  void getimage()async {
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    setState(()  { Url =  (snap.data() as Map<String,dynamic>)['image_url'];});








  }

  Uint8List? _pickedimagefile;
  void _pickimage()async{
    final image = await  Pickimage(ImageSource.gallery);
    setState(()  {
      _pickedimagefile=  image;
    });
    widget.onpickedimage(_pickedimagefile!);

  }

  @override
  Widget build(BuildContext context) {
    getimage();
    return Column(
      children: [


        Url!=null?
        CircleAvatar(radius: 100,backgroundImage: NetworkImage(Url!),)
            :
        CircleAvatar(radius: 100,backgroundColor: Colors.blueGrey,foregroundImage:_pickedimagefile!=null?Image.memory(_pickedimagefile!) as ImageProvider:null,),
        TextButton.icon(
            onPressed: _pickimage,
            icon: const Icon(Icons.image,color: Color.fromARGB(255, 125, 216, 197),),
            label: const Text('Add Image',style: TextStyle(color: Color.fromARGB(255, 125, 216, 197),),))
      ],
    );
  }
}
