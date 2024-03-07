import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pharmcare/medlist_temp.dart';
class scan_info extends StatefulWidget{
  const scan_info({super.key,required this.name});
final name;

  @override
  State<scan_info> createState() => _scan_infoState();
}

class _scan_infoState extends State<scan_info> {
  //var productDetails;
  Future<List<Map<String, dynamic>>> fetchProductDetails(String productName) async {
    final response = await http.post(
      Uri.parse('http://192.168.0.229:5000/search'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"product_name": productName}),
    );

    if (response.statusCode == 200) {
      Iterable responseBody = json.decode(response.body);
      return List<Map<String, dynamic>>.from(responseBody);
    } else {
      throw Exception('Failed to fetch product details');
    }
  }

  /*void main() async {
    try {
      productDetails = await fetchProductDetails("thyronorm");
      print(productDetails);
    } catch (e) {
      print(e);
    }
  }
@override
  void initState() {
    main();
    super.initState();
  }*/
  @override
  Widget build(BuildContext context) {

 return
    FutureBuilder<List<dynamic>>(
     future: fetchProductDetails(widget.name),
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
           physics: NeverScrollableScrollPhysics(),
           shrinkWrap: true,
           itemCount: products.length,
           itemBuilder: (context, index) {
             var product = products[index];
             return medtemp(medicine: product);
           },
         );
       }
     },
   );

  }
}