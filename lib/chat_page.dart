import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmcare/Doctor.dart';
import 'package:pharmcare/chat_bubble.dart';
import 'package:pharmcare/chat_service.dart';
import 'package:pharmcare/message_model.dart';
import 'package:pharmcare/pick_image.dart';

class chat_page extends StatefulWidget {
  const chat_page(
      {super.key,  required this.receiveruserid,required this.doc_name,required this.pat_name});

  //final receiveremail;
  final receiveruserid;
  final doc_name;
  final pat_name;

  @override
  State<StatefulWidget> createState() {
    return _chatpagestate();
  }

}

class _chatpagestate extends State<chat_page>{
  var selectedMessage;
  final TextEditingController msgcontroller = TextEditingController();
  final chatservice _chatservice= chatservice();
  final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String username="username";
  String imageUrl='';
  String reply='';
  String? replyImageUrl;

  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    _firestore.collection("users").doc(_firebaseAuth.currentUser!.uid).get().then((value){
      setState(() {
        var data = value.data();
        if (data != null) {
          username = data['username'] ?? "User";
        }


      });
    });

  }

  void sendmessage()async{
    if(msgcontroller.text.isNotEmpty){
      var messageToReplyTo;
      if (selectedMessage != null) {
        var messageData = selectedMessage;
        if (messageData != null) {
          messageToReplyTo = messageData['message'];
        }
      }
      await _chatservice.sendmessage(widget.receiveruserid, msgcontroller.text, widget.doc_name, widget.pat_name ?? "patient", username, replyImageUrl ?? messageToReplyTo, imageUrl!);

      msgcontroller.clear();
      setState(() {
        selectedMessage = null;
        replyImageUrl = null;
      });
    }

}
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:  () async {
        Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    Doctor(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor: Color.fromARGB(100, 125, 216, 197),),
        body: Column(children: [
          Expanded(child: _builMessagelist(),),
          _buildMessageinput(),
          SizedBox(height: 25,),
        ],),),
    );
  }

  Widget _builMessagelist(){
    return StreamBuilder(stream: _chatservice.getMessages(widget.receiveruserid, _firebaseAuth.currentUser!.uid),
        builder:(context,snapshot){
      if(snapshot.hasError){
        return Text('error'+snapshot.error.toString());
      }
      if(snapshot.connectionState==ConnectionState.waiting){
        return Center(child: CircularProgressIndicator(),);
      }
      return ListView(
        children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
      );
    });
  }

  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String,dynamic> data = document.data() as Map<String,dynamic>;
    print(data['SenderId']);

    var alignment = (data['SenderId']==_firebaseAuth.currentUser!.uid)
    ?Alignment.centerRight:
        Alignment.centerLeft;
    Widget messageContent;
    if (data['imageUrl'] != null && data['imageUrl'].isNotEmpty) {
      messageContent = chatbubble(isSender: data['SenderId'] == _firebaseAuth.currentUser!.uid, message: data['imageUrl']);

    } else {
      messageContent = chatbubble(isSender: data['SenderId'] == _firebaseAuth.currentUser!.uid, message: data['message']);

    }
    List<Widget> messageWidgets = [Text(data['SenderName'])];

    if (data['replyTo'] != null && data['replyTo'].isNotEmpty) {

      bool isReplyToImage = data['replyTo'].startsWith('http://') || data['replyTo'].startsWith('https://');

      Widget replyContent = isReplyToImage
          ? Image.network(data['replyTo'], width: 50, height: 50, fit: BoxFit.cover)
          : Text("Replying to: ${data['replyTo']}");

      messageWidgets.add(
          Container(
              margin: EdgeInsets.only(top: 4, bottom: 4),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.grey[200],
              child: replyContent
          )
      );
    }
    messageWidgets.add(SizedBox(height: 4,));
    messageWidgets.add(messageContent);
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        setState(() {
          selectedMessage = data;
          if (data['imageUrl'] != null && data['imageUrl'].isNotEmpty) {
            replyImageUrl = data['imageUrl'];
          } else {
            replyImageUrl = null;
          }
        });
      },
      child: Container(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
          child: Column(
            crossAxisAlignment: (data['SenderId']==_firebaseAuth.currentUser!.uid)?CrossAxisAlignment.end:CrossAxisAlignment.start,
            children: messageWidgets,/*[Text(data['SenderName']),
            SizedBox(height: 4,),
            messageContent,
            ],*/
          ),
        ),
      ),
    );
  }
  Widget _buildMessageinput(){
    var selectedMessageData = selectedMessage as Map<String, dynamic>?;
    return Column(
      children: [
        if (selectedMessage != null) ...[
          ListTile(
            title: Text(selectedMessage['SenderName'] ?? ''),
            subtitle: (selectedMessage['imageUrl'] != null && selectedMessage['imageUrl'].isNotEmpty)
                ? Image.network(selectedMessage['imageUrl'])
                : Text(selectedMessage['message'] ?? ''),
            trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  selectedMessage = null;
                });
              },
            ),
          ),
          Divider()
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25,),
          child: Row(children: [
            IconButton(
              icon: Icon(Icons.image),
              onPressed: () async {
                final bytes = await Pickimage(ImageSource.gallery);
                if (bytes != null) {
                  sendImageMessage(bytes);
                }
              },
            ),
            Expanded(child: TextField(
              controller: msgcontroller,
            decoration: InputDecoration(hintText: 'Enter message'),

            obscureText:false,
            ),
          ),
            IconButton(onPressed: sendmessage, icon: Icon(Icons.arrow_upward,size: 40,))
          ],
          ),
        ),
      ],
    );
  }

  Future<String> uploadImageToFirebaseStorage(Uint8List bytes) async {
    String filePath = 'chat_images/${DateTime.now().toIso8601String()}.png';
    await FirebaseStorage.instance.ref(filePath).putData(bytes);
    return FirebaseStorage.instance.ref(filePath).getDownloadURL();
  }

  void sendImageMessage(Uint8List bytes) async {
    String? uploadedImageUrl = await uploadImageToFirebaseStorage(bytes);
    if (uploadedImageUrl != null) {
      // Use the uploadedImageUrl as the message or a field in the message
      await _chatservice.sendmessage(
          widget.receiveruserid,
          "Image",
          widget.doc_name,
          widget.pat_name ?? "patient",
          username,
          replyImageUrl ?? "",
          uploadedImageUrl
      );
    }


  }


}