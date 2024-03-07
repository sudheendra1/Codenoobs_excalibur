

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmcare/API.dart';
import 'package:pharmcare/product.dart';
import 'package:pharmcare/scan_info.dart';

class Bar extends StatefulWidget{
  const Bar({super.key,required this.bar});
final bar;
  @override
  State<StatefulWidget> createState() {
    return _Barststate();
  }

}

class _Barststate extends State<Bar>{
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts(widget.bar);
  }


  @override
  Widget build(BuildContext context) {
   return Scaffold(body: FutureBuilder<List<Product>>(
     future: futureProducts,
     builder: (context, snapshot) {
       if (snapshot.connectionState == ConnectionState.waiting) {
         return Center(child: CircularProgressIndicator());
       } else if (snapshot.hasError) {
         return Center(child: Text('Error: ${snapshot.error}'));
       } else {
         final products = snapshot.data!;
         return ListView.builder(
             itemCount: products.length,
             itemBuilder: (context, index) {
               final product = products[index];
               return scan_info(name:product.title);
             }
         );
       }

     }
   ),);
  }

}