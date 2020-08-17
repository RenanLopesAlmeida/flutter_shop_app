import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/providers/products_provider.dart';
import 'package:shop_app/src/screens/user_products_screen/widgets/user_product_item.dart';
import 'package:shop_app/src/shared/widgets/app_drawer_widget.dart';

class UserProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _products = Provider.of<ProductsProvider>(context);

    Function deleteProduct(String id) {
      _products.deleteProduct(id);
    }

    return Scaffold(
      backgroundColor: Color(0xfff7f7f7),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/edit-product-screen');
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: _products.products.length,
          itemBuilder: (context, index) => UserProductItem(
            id: _products.products[index].id,
            title: _products.products[index].title,
            imageUrl: _products.products[index].imageUrl,
            deleteProduct: deleteProduct,
          ),
        ),
      ),
    );
  }
}
