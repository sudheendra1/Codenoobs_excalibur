import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmcare/home_page.dart';
import 'package:pharmcare/signup.dart';

final _auth = FirebaseAuth.instance;
bool _isloading = false;


class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() {
    return _loginpagestate();
  }
}

class _loginpagestate extends State<Loginpage> {



  final pass=TextEditingController();
  final em= TextEditingController();

  var _enteredemail = '';
  var _enteredpassword = '';
    final _formkey = GlobalKey<FormState>();

void submit()async {
  setState(() {
    _isloading=true;
  });
  final _isvalid = _formkey.currentState!.validate();
  if (!_isvalid) {
    setState(() {
      _isloading=false;
    });
    return;
  }
  _formkey.currentState!.save();
  try{
    final usercredetials = await _auth.signInWithEmailAndPassword(
        email: _enteredemail, password: _enteredpassword);
    if (usercredetials.user!.emailVerified == false) {
      setState(() {
        _isloading=false;
      });
      usercredetials.user!.sendEmailVerification();
      usercredetials.user!.reload();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Check your Email for verification')));
      em.clear();
      pass.clear();
    } else {
      setState(() {
        _isloading=false;
      });
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const Homepage()));
    }
  } on FirebaseAuthException catch (error) {
    if (error.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message ?? 'Authentication failed'),
      ));
      setState(() {
        _isloading=false;
      });
    }
  }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{SystemNavigator.pop();
        return true;},
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Sign In',style: TextStyle(color: Colors.black87)),
          backgroundColor: Color.fromARGB(100, 125, 216, 197),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', height: 200),
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
                  ElevatedButton(onPressed: submit, child:_isloading?const Center(child: CircularProgressIndicator(color: Colors.purpleAccent,),): Text('Sign In',style: TextStyle(color: Colors.black),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(100, 125, 216, 197),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Image.asset("assets/images/google_logo.png", height: 24.0), // Adjust this path
                    label: Text("Sign in with Google"),
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: Image.asset("assets/images/Facebook.png", height: 24.0), // Adjust this path
                    label: Text("Sign in with Facebook"),
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Signup()));
                    },
                    child: Text('Don\'t have an account? Sign Up'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
