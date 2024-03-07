
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

Pickimage(ImageSource source)async{
  final ImagePicker _imagepicker= ImagePicker();
  XFile? _pickedimage= await  _imagepicker.pickImage(source: source);
  if(_pickedimage!=null){
    return await _pickedimage.readAsBytes();
  }

}
showSnackbar(String content, BuildContext context){
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}