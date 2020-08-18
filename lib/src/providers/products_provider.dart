import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/src/config/services/api.dart';
import 'package:shop_app/src/providers/product.dart';
import 'package:shop_app/src/server/dummy_product_data.dart';

import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _products = ProductsData.products;
  final url = '${API.BASE_URL}products.json';

  List<Product> get products {
    return [..._products];
  }

  Product findById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  Future<void> addProduct(Product product) async {
    final productJson = json.encode({
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'isFavorite': product.isFavorite
    });
    try {
      final response = await http.post(url, body: productJson);

      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );

      _products.add(newProduct);
      notifyListeners();
    } catch (error) {
      print("An error has occurred: $error");
      throw error;
    }
  }

  List<Product> get favoriteItems {
    return _products.where((element) => element.isFavorite).toList();
  }

  void updateProduct(String id, Product newProduct) {
    final productId = _products.indexWhere((product) => product.id == id);
    if (productId >= 0) {
      _products[productId] = newProduct;
      notifyListeners();
    } else {
      print('Product id not found');
    }
  }

  void deleteProduct(String productId) {
    _products.removeWhere((product) => product.id == productId);
    notifyListeners();
  }
}
