import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pharmcare/product.dart';

Future<List<Product>> fetchProducts(
  String barcode,
) async {
  final response = await http.get(Uri.parse(
      'https://api.barcodelookup.com/v3/products?barcode=' +
          barcode +
          '&formatted=y&key=syek560ibh4tz7e2qfsb1uux1tu5sc'));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return (jsonResponse['products'] as List)
        .map((productJson) => Product.fromJson(productJson))
        .toList();
  } else {
    throw Exception('Failed to load data');
  }
}
