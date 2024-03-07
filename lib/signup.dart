import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmcare/Auth_method.dart';
import 'package:pharmcare/Doctor.dart';
import 'package:pharmcare/home_page.dart';
import 'package:pharmcare/login_page.dart';
import 'package:pharmcare/personel_details.dart';

final _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
bool _isloading = false;

class Signup extends StatefulWidget{
  const Signup({super.key});

  @override
  State<StatefulWidget> createState() {
    return signupstate();
  }

}

class signupstate extends State<Signup>{
  bool _isChecked = false;
  bool _isDoctor = false;
  final uername = TextEditingController();
  final pass=TextEditingController();
  final em= TextEditingController();
  final cp= TextEditingController();
  final deg= TextEditingController();
  final exp= TextEditingController();
  var _enteredemail = '';
  var _enteredpassword = '';
  var _enteredusername = '';
  var _enteredspeciality='Select speciality';
  var _entereddegree = '';
  var _entered_experience='';
  final specialities = <String>['Allergist','Cardiologist','Dermatologist','Endocrinologist','Gastroenterologist','Gynecologist','Hepatologist','Internal Medcine','Neurologist','Osteopathic','Otolaryngologist','Pediatrician','Phlebologist','Pulmonologist','Rheumatologists','Tuberculosis'];

  final _formkey = GlobalKey<FormState>();

  void _submit() async {
    if (_isChecked == true) {


    setState(() {
      _isloading = true;
    });
    final _isvalid = _formkey.currentState!.validate();
    if (!_isvalid) {
      setState(() {
        _isloading = false;
      });
      return;
    }
    _formkey.currentState!.save();
    try {
      print(_enteredusername);
      String res = await Auth_method().signup(
          username: _enteredusername,
          emailid: _enteredemail,
          password: _enteredpassword,
          Doctor:_isDoctor);


      setState(() {
        _isloading = false;
      });
      /*if (FirebaseAuth.instance.currentUser!.emailVerified == false) {
        FirebaseAuth.instance.currentUser!.sendEmailVerification();
        FirebaseAuth.instance.currentUser!.reload();
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Check your Email for verification')));
        uername.clear();
        em.clear();
        pass.clear();
        cp.clear();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Loginpage()));
      }*/
      if (res == 'success') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User created successfully'),
          duration: Duration(milliseconds: 8),));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const personel()));
        setState(() {
          _isloading = false;
        });
      }

      else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Something went wrong!! Try again'),
          duration: Duration(milliseconds: 8),));
        setState(() {
          _isloading = false;
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.message ?? 'Authentication failed'),
        ));
        setState(() {
          _isloading = false;
        });
      }
    }
  }
    else{
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("please accept the terms and conditions"),
      ));
      setState(() {
        _isloading = false;
      });

    }
    if(_isDoctor==true){
      await _firestore.collection('Doctors').doc(_enteredspeciality).collection('doctors_list').doc(FirebaseAuth.instance.currentUser!.uid).set({
        'UID': FirebaseAuth.instance.currentUser!.uid,
        'Name': _enteredusername,
        'Degree': _entereddegree,
        'Experience': _entered_experience,
        'Email': FirebaseAuth.instance.currentUser!.email,


      });
      await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
       'Speciality':_enteredspeciality,


      });

    }
  }

 /* Future<UserCredential> googlesignin() async {
    final GoogleSignInAccount? guser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gauth = await guser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gauth.accessToken,
      idToken: gauth.idToken,
    );
    final auth = await FirebaseAuth.instance.signInWithCredential(credential);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.user!.uid)
        .set({
      'username': guser.displayName,
      'email_id': guser.email,
      'image_url': guser.photoUrl,
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Homepage()));
    return auth;
  }*/
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:  () async {
        Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    Loginpage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Sign Up'),
          backgroundColor: Color.fromARGB(100, 125, 216, 197),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formkey,
            child: ListView(
              children: [
                Image.asset('assets/images/logo.png', height: 200),
                SizedBox(height: 20),
                TextFormField(
                  controller: uername,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    labelText: 'Full Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                    prefixIcon: Icon(Icons.person),
                  ),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter an username';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredusername = value!;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: em,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    labelText: 'Email ID',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid Email Address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredemail = value!;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: pass,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    labelText: 'Password',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length < 8) {
                      return 'Password must be atleast 8 characters long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredpassword = value!;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: cp,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != _enteredpassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Plaease enter correct password')));
                    }
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: _isDoctor,
                      onChanged: (bool? value) {
                        setState(() {
                          _isDoctor = value!;
                        });
                      },
                    ),
                    Text('Doctor'),
                  ],
                ),
                SizedBox(height: 20),
                _isDoctor?
                DropdownButton<String>(
                  hint: Text(_enteredspeciality),
                  items: specialities
                      .where((symptom) => !_enteredspeciality.contains(symptom))
                      .map((symptom) => DropdownMenuItem(
                    value: symptom,
                    child: Text(symptom),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null ) {
                      setState(() {
                        _enteredspeciality=value;

                      });
                    }
                  },
                ):SizedBox(),
                SizedBox(height: 10),
                _isDoctor?
                TextFormField(
                  controller: deg,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    labelText: 'Degree',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),

                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a degree';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _entereddegree= value!;
                  },
                ):SizedBox(),
                SizedBox(height: 10),
                _isDoctor?
                TextFormField(
                  controller:exp,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    labelText: 'Experience',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),

                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Experience';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _entered_experience= value!;
                  },
                ):SizedBox(),


                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      },
                    ),
                    Text('i understand the terms and conditions'),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(onPressed: _submit, child:_isloading?const Center(child: CircularProgressIndicator(color: Colors.purpleAccent,),): Text('Sign Up',style: TextStyle(color: Colors.black),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(100, 125, 216, 197),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),),

              ],
            ),
          ),
        ),
      ),
    );
  }

}