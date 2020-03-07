import 'dart:convert';
import 'package:latlong/latlong.dart';
import 'package:link/models/product.dart';
import 'package:http/http.dart' as http;

class Utility{
  List<Products> _products = List<Products>();

  Future<List<Products>> getProducts() async {
    print("fetching products");
    const url = 'http://hitwo-api.herokuapp.com/products';
    var products = List<Products>();
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        print('decoding response');
        var productsJson = json.decode(response.body);
        for (var productJson in productsJson) {
          products.add(Products.fromJSON(productJson));
        }
      }
    } on Exception catch (e) {
      print("$e");
    }
    _products = [];
    for (var product in products) {
      _products.add(product);
    }
  }

  Future<List<Products>> search(value) async{
    await getProducts();
    List<Products> byName = _products.where((element) => element.name == value);
    print(byName);
    return byName;
  }
}
