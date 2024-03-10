import 'dart:typed_data';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmcare/pick_image.dart';
import 'package:pharmcare/record_model.dart';
import 'package:path/path.dart' as path;

class upload_records extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _uploadstate();
  }
}

class _uploadstate extends State<upload_records> {
  final _titlecontroller = TextEditingController();
  Uint8List? _file;
  File? file;
  String pdf_url = '';
  bool _isloadin = false;
  String fileName = '';

  _selectimage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Select image'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await Pickimage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose form gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await Pickimage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
            ],
          );
        });
  }

  void upload() async {
    setState(() {
      _isloadin = true;
    });
    String iurl = '';

    if (_file != null) {
      final storageref = FirebaseStorage.instance
          .ref()
          .child('Records')
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child(_titlecontroller.text);
      TaskSnapshot snap = await storageref.putData(_file!);

      iurl = await snap.ref.getDownloadURL();
    }
    if (file != null) {
      UploadTask? task = await uploadFile(file);
    }

    String res = await Record_model()
        .Upload(title: _titlecontroller.text, image: iurl, pdfurl: pdf_url);
    if (res == 'success') {
      setState(() {
        _isloadin = false;
      });
      showSnackbar('Uploaded!', context);
      Navigator.of(context).pop();
    } else {
      setState(() {
        _isloadin = false;
      });
      showSnackbar(res, context);
      Navigator.of(context).pop();
    }
  }

  Future<firebase_storage.UploadTask?>? uploadFile(File? file) async {
    if (file == null) {
      return null;
    }

    firebase_storage.UploadTask uploadTask;

    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('Records')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(_titlecontroller.text);

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'file/pdf',
        customMetadata: {'picked-file-path': file.path});
    print("Uploading..!");

    TaskSnapshot snap = await ref.putData(await file.readAsBytes(), metadata);
    pdf_url = await snap.ref.getDownloadURL();

    print("done..!");
    return null;
  }

  String getFileNameFromPath(String filePath) {
    return path.basename(filePath);
  }

  @override
  void dispose() {
    super.dispose();
    _titlecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titlecontroller,
            maxLength: 20,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          SizedBox(
            height: 20,
          ),
          _file != null
              ? Expanded(
                  flex: 1,
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: MemoryImage(_file!), fit: BoxFit.fill)),
                  ))
              : OutlinedButton(
                  onPressed: () => _selectimage(context),
                  child: Image.network(
                      "https://t4.ftcdn.net/jpg/04/81/13/43/360_F_481134373_0W4kg2yKeBRHNEklk4F9UXtGHdub3tYk.jpg"),
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size.square(250),
                    shape: RoundedRectangleBorder(),
                  )),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    final path = await FlutterDocumentPicker.openDocument();
                    print(path);
                    file = File(path!);
                    fileName = getFileNameFromPath(file!.path);
                  },
                  child: file != null ? Text(fileName) : Text('Upload PDF')),
              ElevatedButton(onPressed: upload, child: Text('Record')),
            ],
          )
        ],
      ),
    );
  }
}
