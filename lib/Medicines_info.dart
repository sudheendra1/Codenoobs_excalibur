import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pharmcare/Diagnosis.dart';
import 'package:pharmcare/home_page.dart';
import 'package:pharmcare/medlist_temp.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pharmcare/profile.dart';

class medicineslist extends StatefulWidget{
  const medicineslist({super.key});

  @override
  State<StatefulWidget> createState() {
    return _medicinesliststate();
  }

}

class _medicinesliststate extends State<medicineslist>{
  Stream<List<dynamic>> fetchAllProducts(int limit) async* {
    final response = await http.get(Uri.parse('http://192.168.0.229:5000/all_products?limit=$limit'));

    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      if (decodedResponse is List) {
        yield decodedResponse;
      } else {
        throw Exception(
            'Expected a list but got ${decodedResponse.runtimeType}');
      }
    }else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(elevation: 0.0, title: Text("Medicines"),

      backgroundColor: Color.fromARGB(
          100, 125, 216, 197),),
      bottomNavigationBar: Container(
        color: Color.fromARGB(100, 125, 216, 197),
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 25.0, vertical: 4),
          child: GNav(

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
            tabBackgroundColor:Color.fromARGB(200, 125, 216, 197),
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
      body: StreamBuilder<List<dynamic>>(
        stream: fetchAllProducts(500),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found.'));
          } else {
            List<dynamic> products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                var product = products[index];
                return medtemp(medicine: product);
              },
            );
          }
        },
      ),);
  }

}