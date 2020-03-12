import 'package:link/models/product.dart';
class Utility{
  List<Products> _products;
  Utility(this._products);

  Future<List<Products>> searchProduct(value)async{
    var result = _products.where((product) => product.name == value);
    return result;
  }
}
