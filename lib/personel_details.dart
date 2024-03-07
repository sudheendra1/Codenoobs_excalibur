import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmcare/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class personel extends StatefulWidget{
  const personel({super.key});

  @override
  State<StatefulWidget> createState() {
   return _personelstate();
  }

}

class _personelstate extends State<personel>{
  var uid= FirebaseAuth.instance.currentUser!.uid;
  bool _isChecked = false;
  final allergies = TextEditingController();
  final DOB=TextEditingController();
  final gender= TextEditingController();
  final diseases= TextEditingController();
  final treatment= TextEditingController();

  var _allergies = '';
  var _DOB = '';
  var _gender = 'Gender';
  var _diseases = '';
  var _treatment = '';
  final _formKey = GlobalKey<FormState>();
  bool _isloading = false;


  _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2023),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null && selectedDate != DateTime.now())
      DOB.text = DateFormat('dd-MM-yyyy').format(selectedDate);
    _DOB=DOB.text;// format the selected date to your desired format
  }

  void _submit()async{
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
    if(treatment.text.isNotEmpty){
FirebaseFirestore.instance.collection('users').doc(uid).update({'Allergies':_allergies,'DOB':_DOB,'Diseases':_diseases,'gender':_gender,'treatments':treatment.text.trim()});
Navigator.push(context, MaterialPageRoute(builder:  (context)=>Homepage()));

    }
    else{
      FirebaseFirestore.instance.collection('users').doc(uid).update({'Allergies':_allergies,'DOB':_DOB,'Diseases':_diseases,'gender':_gender});
      Navigator.push(context, MaterialPageRoute(builder:  (context)=>Homepage()));
    }

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{return false;},
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text("Personel details",style: TextStyle(color: Colors.black87)),
          backgroundColor: Color.fromARGB(100, 125, 216, 197),
        ),
        body: Padding(padding: const EdgeInsets.all(32.0),child: SingleChildScrollView(
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
                  labelText: 'Allergies',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),

                ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'if no allergies then enter none';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _allergies = value!;
                  },
              ),
                SizedBox(height: 20),
                TextFormField(
                  controller: DOB,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                    prefixIcon: Icon(Icons.calendar_month),

                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());  // to prevent opening default keyboard
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
                  items: <String>['Gender','Male', 'Female', 'Other']
                      .map<DropdownMenuItem<String>>((String value1) {
                    return DropdownMenuItem<String>(
                      value: value1,
                      child: Text(value1),
                    );
                  }).toList(),

                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: diseases,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    labelText: 'Chronic Diseases',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),

                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter none if no diseases';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _diseases = value!;
                  },
                ),
                SizedBox(height: 20),
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
                    Text('Under medical treatment?'),
                  ],
                ),
                SizedBox(height: 20),
                _isChecked?
                TextFormField(
                  controller: treatment,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    labelText: 'Treatment details',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),

                  ),
                 /* validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter the type of treatment';
                    }
                    return null;
                  },*/
                  onSaved: (value) {
                    _treatment = value!;
                  },
                ):
                SizedBox(height: 20),
                SizedBox(height: 20),
                ElevatedButton(onPressed: _submit, child: Text('Continue',style: TextStyle(color: Colors.black),),
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
        ),),
      ),
    );
  }
}
