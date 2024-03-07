import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmcare/diagnose_result.dart';
import 'package:pharmcare/home_page.dart';
import 'package:pharmcare/prediction_list.dart';
import 'package:pharmcare/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_nav_bar/google_nav_bar.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<StatefulWidget> createState() {
    return _chatbotstate();
  }
}

class _chatbotstate extends State<Chatbot> {
  int _currentindex = 1;
  final symptoms = <String>[
    'itching',
    'skin_rash',
    'nodal_skin_eruptions',
    'continuous_sneezing',
    'shivering',
    'chills',
    'joint_pain',
    'stomach_pain',
    'acidity',
    'ulcers_on_tongue',
    'muscle_wasting',
    'vomiting',
    'burning_micturition',
    'spotting_ urination',
    'fatigue',
    'weight_gain',
    'anxiety',
    'cold_hands_and_feets',
    'mood_swings',
    'weight_loss',
    'restlessness',
    'lethargy',
    'patches_in_throat',
    'irregular_sugar_level',
    'cough',
    'high_fever',
    'sunken_eyes',
    'breathlessness',
    'sweating',
    'dehydration',
    'indigestion',
    'headache',
    'yellowish_skin',
    'dark_urine',
    'nausea',
    'loss_of_appetite',
    'pain_behind_the_eyes',
    'back_pain',
    'constipation',
    'abdominal_pain',
    'diarrhoea',
    'mild_fever',
    'yellow_urine',
    'yellowing_of_eyes',
    'acute_liver_failure',
    'fluid_overload',
    'swelling_of_stomach',
    'swelled_lymph_nodes',
    'malaise',
    'blurred_and_distorted_vision',
    'phlegm',
    'throat_irritation',
    'redness_of_eyes',
    'sinus_pressure',
    'runny_nose',
    'congestion',
    'chest_pain',
    'weakness_in_limbs',
    'fast_heart_rate',
    'pain_during_bowel_movements',
    'pain_in_anal_region',
    'bloody_stool',
    'irritation_in_anus',
    'neck_pain',
    'dizziness',
    'cramps',
    'bruising',
    'obesity',
    'swollen_legs',
    'swollen_blood_vessels',
    'puffy_face_and_eyes',
    'enlarged_thyroid',
    'brittle_nails',
    'swollen_extremeties',
    'excessive_hunger',
    'extra_marital_contacts',
    'drying_and_tingling_lips',
    'slurred_speech',
    'knee_pain',
    'hip_joint_pain',
    'muscle_weakness',
    'stiff_neck',
    'swelling_joints',
    'movement_stiffness',
    'spinning_movements',
    'loss_of_balance',
    'unsteadiness',
    'weakness_of_one_body_side',
    'loss_of_smell',
    'bladder_discomfort',
    'foul_smell_of urine',
    'continuous_feel_of_urine',
    'passage_of_gases',
    'internal_itching',
    'toxic_look_(typhos)',
    'depression',
    'irritability',
    'muscle_pain',
    'altered_sensorium',
    'red_spots_over_body',
    'belly_pain',
    'abnormal_menstruation',
    'dischromic _patches',
    'watering_from_eyes',
    'increased_appetite',
    'polyuria',
    'family_history',
    'mucoid_sputum',
    'rusty_sputum',
    'lack_of_concentration',
    'visual_disturbances',
    'receiving_blood_transfusion',
    'receiving_unsterile_injections',
    'coma',
    'stomach_bleeding',
    'distention_of_abdomen',
    'history_of_alcohol_consumption',
    'fluid_overload',
    'blood_in_sputum',
    'prominent_veins_on_calf',
    'palpitations',
    'painful_walking',
    'pus_filled_pimples',
    'blackheads',
    'scurring',
    'skin_peeling',
    'silver_like_dusting',
    'small_dents_in_nails',
    'inflammatory_nails',
    'blister',
    'red_sore_around_nose',
    'yellow_crust_ooze',
    'none'
  ];
  final selectedSymptoms = <String>[];
  String? prediction;
  String? description;
  var precaution;
  String? doctor;
  int count= 6;
  String firstsymptom='select';
  String secondsymptom='select';
  String thirdsymptom='select';
  String fourthsymptom='select';
  String fifthsymptom='select';
  String sixthsymptom='select';



  Future<void> predictDisease() async {
    if (selectedSymptoms.length < 4 || selectedSymptoms.length > 6) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text('Please select between 4 to 6 symptoms.'),
          actions: [
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
      return;
    }
    final response = await http.post(
      Uri.parse('http://192.168.0.229:5000/predict'),
      body: jsonEncode({'symptoms': selectedSymptoms}),
      headers: {"Content-Type": "application/json"},
    );

    final responseData = jsonDecode(response.body);
    print(responseData.length);
   print(responseData);
    setState(() {
      prediction = responseData['disease'];
      description = responseData['description'][0]['Symptom_Description'];
      precaution = responseData['precaution'][0];
      doctor = responseData['doctor'][0]['Allergist'];



    });
    if(prediction!=null){
      Navigator.push(
          context,
          PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  diagnose_result(prediction: prediction, description: description, precaution: precaution, doctor: doctor),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero));
    }
  }
  Widget _buildSymptomDropdown(String label, String currentSelection, Function(String?) onChanged, Function onClear) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontFamily: 'Cocogoose'),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(currentSelection),
                  items: symptoms
                      .where((symptom) => !selectedSymptoms.contains(symptom))
                      .map((symptom) => DropdownMenuItem(
                    value: symptom,
                    child: Text(symptom),
                  ))
                      .toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                onClear();
              },
            )
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
        return true;
      },
      child:  DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(100, 125, 216, 197),
              title: Text('Disease predictor'),
              bottom: TabBar(tabs: [Tab(text: 'Diagnose',),Tab(text: 'Records',)]),
            ),

            body:  TabBarView(
              children: [Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    _buildSymptomDropdown('Select first symptom:', firstsymptom, (value) {
                      setState(() {
                        firstsymptom = value!;
                        selectedSymptoms.add(value);
                      });

                    },
                            () {
                          setState(() {
                            selectedSymptoms.remove(firstsymptom);
                            firstsymptom = 'select';
                          });
                        }),
                    _buildSymptomDropdown('Select second symptom:', secondsymptom, (value) {
                      setState(() {
                        secondsymptom = value!;
                        selectedSymptoms.add(value);
                      });
                    },
                            () {
                          setState(() {
                            selectedSymptoms.remove(secondsymptom);
                            secondsymptom = 'select';
                          });
                        }),
                    _buildSymptomDropdown('Select third symptom:', thirdsymptom, (value) {
                      setState(() {
                        thirdsymptom = value!;
                        selectedSymptoms.add(value);
                      });
                    },
                            () {
                          setState(() {
                            selectedSymptoms.remove(thirdsymptom);
                            thirdsymptom = 'select';
                          });
                        }),
                    _buildSymptomDropdown('Select fourth symptom:', fourthsymptom, (value) {
                      setState(() {
                        fourthsymptom = value!;
                        selectedSymptoms.add(value);
                      });
                    },
                            () {
                          setState(() {
                            selectedSymptoms.remove(fourthsymptom);
                            fourthsymptom = 'select';
                          });
                        }),
                    _buildSymptomDropdown('Select fifth symptom:', fifthsymptom, (value) {
                      setState(() {
                        fifthsymptom = value!;
                        selectedSymptoms.add(value);
                      });
                    },
                            () {
                          setState(() {
                            selectedSymptoms.remove(fifthsymptom);
                            fifthsymptom = 'select';
                          });
                        }),
                    _buildSymptomDropdown('Select sixth symptom:', sixthsymptom, (value) {
                      setState(() {
                       sixthsymptom = value!;
                        selectedSymptoms.add(value);
                      });
                    },
                            () {
                          setState(() {
                            selectedSymptoms.remove(sixthsymptom);
                            sixthsymptom = 'select';
                          });
                        }),

                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Color.fromARGB(100, 125, 216, 197),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // Rounded corners
                          ),
                          elevation: 5, // Shadow
                        ),
                        onPressed: predictDisease,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            Text('Predict Disease'),
                          ],
                        ),
                      ),
                    ),

                    if (prediction != null) Center(child: Text('Predicted Disease: $prediction')),
                  ],
                ),
              ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Predictions').doc(FirebaseAuth.instance.currentUser!.uid).collection('Predictions').snapshots(),
                  builder:  (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) => Pred_list(snap: snapshot.data!.docs[index].data(),));
                  },
                ),
              ],
            ),



          bottomNavigationBar: Container(
            color: Color.fromARGB(100, 125, 216, 197),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 25.0, vertical: 4),
              child: GNav(
                selectedIndex: _currentindex,
                style: GnavStyle.oldSchool,
                textSize: 10,

                onTabChange: (index) {
                  if (index == 0) {
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                Homepage(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero));
                  }
                  if (index == 1) {
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                Chatbot(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero));
                  }
                  if (index == 2) {
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                Profile(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero));
                  }

                },
                //backgroundColor: Color.fromARGB(100, 125, 216, 197),
                color: Colors.black,
                activeColor: Colors.black,
                tabBorderRadius: 10,
                tabBackgroundColor:Color.fromARGB(100, 125, 216, 197),
                haptic: true,
                hoverColor: Color.fromARGB(150, 125, 216, 197),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                //tabBackgroundColor: Colors.blueGrey.shade900,

                duration: Duration(milliseconds: 900),
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                    gap: 10,
                  ),
                  GButton(
                    icon: Icons.chat_rounded,
                    text: 'Diagnose',
                    gap: 10,
                  ),

                  GButton(
                    icon: Icons.person,
                    text: 'Profile',
                    gap: 10,
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
