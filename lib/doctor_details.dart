import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmcare/profile.dart';
import 'package:path/path.dart' as path;

class Dpersonel extends StatefulWidget {
  const Dpersonel({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Dpersonelstate();
  }
}

class _Dpersonelstate extends State<Dpersonel> {
  var uid = FirebaseAuth.instance.currentUser!.uid;
  final allergies = TextEditingController();
  final DOB = TextEditingController();
  final gender = TextEditingController();
  final diseases = TextEditingController();
  final treatment = TextEditingController();
  final speciality = TextEditingController();
  final fees = TextEditingController();
  final school = TextEditingController();

  var _allergies = '';
  var _DOB = '';
  var _gender = 'Gender';
  var _diseases = '';
  var _treatment = '';
  var _speciality = '';
  var _fees = '';
  var _school = '';
  final _formKey = GlobalKey<FormState>();
  bool _isloading = false;
  File? file;
  String pdf_url = '';
  String fileName = '';

  _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2023),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null && selectedDate != DateTime.now())
      DOB.text = DateFormat('dd-MM-yyyy').format(selectedDate);
    _DOB = DOB.text; // format the selected date to your desired format
  }

  String getFileNameFromPath(String filePath) {
    return path.basename(filePath);
  }
  Future<firebase_storage.UploadTask?>? uploadFile(File? file) async {
    if (file == null) {
      return null;
    }



    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('Doctor_certificates')
        .child(FirebaseAuth.instance.currentUser!.uid);


    final metadata = firebase_storage.SettableMetadata(
        contentType: 'file/pdf',
        customMetadata: {'picked-file-path': file.path});
    print("Uploading..!");

    TaskSnapshot snap = await ref.putData(await file.readAsBytes(), metadata);
    pdf_url = await snap.ref.getDownloadURL();

    print("done..!");
    return null;
  }
  void _submit() async {
    setState(() {
      _isloading = true;
    });
    final _isvalid = _formKey.currentState!.validate();
    if (!_isvalid) {
      setState(() {
        _isloading = false;
      });
      return;
    }
    _formKey.currentState!.save();
    if (file!=null) {
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'About': _allergies,
        'DOB': _DOB,
        'Working': _diseases,
        'gender': _gender,
        'Previous_work': _treatment,
        'college':_school,
        'Other_speciality':_speciality,
        'fees':_fees,
        'Certificate_url': pdf_url,

      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Profile()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please upload a certificate')));

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => Profile(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title:
          Text("Personel details", style: TextStyle(color: Colors.black87)),
          backgroundColor: Color.fromARGB(100, 125, 216, 197),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', height: 200),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: allergies,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      labelText: 'About',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter information about yourself';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _allergies = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: school,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      labelText: 'Enter Medical college attended',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the medical college details';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _school = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: diseases,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      labelText: 'Currently working at',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter current employment';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _diseases = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: treatment,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      labelText: 'Previous work experience',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                     validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter previous work experience';
                    }
                    return null;
                  },
                    onSaved: (value) {
                      _treatment = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: speciality,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      labelText: 'Other specialization/expertize',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the details of expertize';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _speciality = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: fees,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      labelText: 'Enter Fees for consultation',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the fees taken';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _fees = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: DOB,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      labelText: 'Date of Birth',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      prefixIcon: Icon(Icons.calendar_month),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(
                          new FocusNode()); // to prevent opening default keyboard
                      _selectDate(context);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter date of birth';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _DOB = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    hint: Text('Select Gender'),
                    value: _gender,
                    onChanged: (String? newValue) {
                      setState(() {
                        _gender = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a gender';
                      }
                      return null;
                    },
                    items: <String>['Gender', 'Male', 'Female', 'Other']
                        .map<DropdownMenuItem<String>>((String value1) {
                      return DropdownMenuItem<String>(
                        value: value1,
                        child: Text(value1),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () async {
                        final path = await FlutterDocumentPicker.openDocument();
                        print(path);
                        file = File(path!);
                        fileName = getFileNameFromPath(file!.path);
                      },
                      child: file != null ? Text(fileName) : Text('Upload Certificate/Licence')),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text(
                      'Continue',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(100, 125, 216, 197),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                      EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
