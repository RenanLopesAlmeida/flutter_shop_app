import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/src/config/services/api.dart';
import 'package:shop_app/src/providers/product.dart';

import 'package:http/http.dart' as http;
import 'package:shop_app/src/shared/exceptions/http_exception.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = [];

  final String authToken;
  final String userId;

  ProductsProvider(this.authToken, this.userId, this._products);

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

  Future<void> fetchProducts([bool filterByUser = false]) async {
    try {
      final filterString =
          filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';

      var productsUrl =
          '${API.BASE_URL}products.json?auth=$authToken$filterString';
      final response = await http.get(productsUrl);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }

      productsUrl = '${API.BASE_URL}userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(productsUrl);
      final favoriteData = jsonDecode(favoriteResponse.body);

      final List<Product> _loadedProducts = [];

      extractedData.forEach((productId, productData) {
        _loadedProducts.add(Product(
          id: productId,
          title: productData['title'],
          price: productData['price'],
          description: productData['description'],
          isFavorite:
              (favoriteData == null) ? false : favoriteData[productId] ?? false,
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
      'creatorId': userId,
    });

    try {
      final productsUrl = '${API.BASE_URL}products.json?auth=$authToken';
      final response = await http.post(productsUrl, body: productJson);

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
      final baseUrl = '${API.BASE_URL}products/$id.json?auth=$authToken';
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
    final baseUrl = '${API.BASE_URL}products/$productId.json?auth=$authToken';

    final _existingProductIndex =
        _products.indexWhere((product) => product.id == productId);
    var _existingProduct = _products[_existingProductIndex];
    _products.removeAt(_existingProductIndex);
    notifyListeners();

    final response = await http.delete(baseUrl);
    if (response.statusCode >= 400) {
      _products.insert(_existingProductIndex, _existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }

    _existingProduct = null;
  }
}
