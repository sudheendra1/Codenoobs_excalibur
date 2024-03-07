import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:pharmcare/medlist_temp.dart';





class SearchPage extends StatefulWidget {



  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  String _searchQuery = '';
  List<dynamic> _results = [];
  Timer _debounce=Timer(Duration.zero, () {});

  Future<void> _searchProduct() async {
    final response = await http.post(
      Uri.parse('http://192.168.0.229:5000/search'),
      body: json.encode({'product_name': _searchQuery}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        _results = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to search products');
    }
  }

  _onSearchChanged(String query) {
    if (_debounce.isActive ) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 30), () {
      if (query == _searchQuery) return;
      _searchQuery = query;
      _searchProduct();
    });
  }

  @override
  void dispose() {
    _debounce.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(100, 125, 216, 197),
        title: SizedBox(
          height: 40,
          width: 300,
          child: TextField(
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: 'Search for medicine',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0)),
            suffixIcon: Icon(Icons.search),
          ),
      ),
        ),),
      body:   ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  var product = _results[index];
                  return medtemp(medicine: product,);
                },
              ),


    );
  }
}
