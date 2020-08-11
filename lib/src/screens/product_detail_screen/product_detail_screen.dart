import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _productId = ModalRoute.of(context).settings.arguments as String;
    final _product = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findById(_productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(_product.title),
      ),
    );
  }
}
