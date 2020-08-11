import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/providers/products_provider.dart';
import 'package:shop_app/src/shared/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;

  ProductsGrid({this.showFavorites});
  @override
  Widget build(BuildContext context) {
    final _productData = Provider.of<ProductsProvider>(context);
    final _products =
        showFavorites ? _productData.favoriteItems : _productData.products;

    return GridView.builder(
      itemCount: _products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: _products[index],
          child: ProductItem(),
        );
      },
    );
  }
}
