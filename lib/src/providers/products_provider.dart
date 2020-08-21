import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/src/config/services/api.dart';
import 'package:shop_app/src/providers/product.dart';

import 'package:http/http.dart' as http;
import 'package:shop_app/src/shared/exceptions/http_exception.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = [];
  final url = '${API.BASE_URL}products.json';

  List<Product> get products {
    return [..._products];
  }

  Product findById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  String getProductImageUrl(String id) {
    final product = findById(id);
    return product.imageUrl;
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }

      final List<Product> _loadedProducts = [];

      extractedData.forEach((productId, productData) {
        _loadedProducts.add(Product(
          id: productId,
          title: productData['title'],
          price: productData['price'],
          description: productData['description'],
          isFavorite: productData['isFavorite'],
          imageUrl: productData['imageUrl'],
        ));
      });

      _products = _loadedProducts;
      notifyListeners();
    } catch (error) {
      print('ERROR in fetching products: $error');
      throw error;
    }
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

  Future<void> updateProduct(String id, Product newProduct) async {
    final productId = _products.indexWhere((product) => product.id == id);
    if (productId >= 0) {
      final baseUrl = '${API.BASE_URL}products/$id.json';
      try {
        await http.patch(baseUrl,
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
              'price': newProduct.price,
            }));
        _products[productId] = newProduct;
        notifyListeners();
      } catch (error) {
        print('Could nout update this product. Error: $error');
        //TODO: throw an error and handle it on the ui
      }
    } else {
      print('Product id not found');
    }
  }

  Future<void> deleteProduct(String productId) async {
    final baseUrl = '${API.BASE_URL}products/$productId.json';

    final _existingProductIndex =
        _products.indexWhere((product) => product.id == productId);
    var _existingProduct = _products[_existingProductIndex];
    _products.removeAt(_existingProductIndex);
    notifyListeners();

    final response = await http.delete(baseUrl); //.then((response) {
    if (response.statusCode >= 400) {
      _products.insert(_existingProductIndex, _existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }

    _existingProduct = null;
  }
}
