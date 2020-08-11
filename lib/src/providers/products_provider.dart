import 'package:flutter/cupertino.dart';
import 'package:shop_app/src/providers/product.dart';
import 'package:shop_app/src/server/dummy_product_data.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = ProductsData.products;

  List<Product> get products {
    return [..._products];
  }

  Product findById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  void addProduct() {
    //_products.add(value);
    notifyListeners();
  }

  List<Product> get favoriteItems {
    return _products.where((element) => element.isFavorite).toList();
  }
}
