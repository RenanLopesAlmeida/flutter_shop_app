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

  void addProduct(Product product) {
    final newProduct = Product(
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      id: DateTime.now().toString(),
    );

    _products.add(newProduct);
    notifyListeners();
  }

  List<Product> get favoriteItems {
    return _products.where((element) => element.isFavorite).toList();
  }
}
