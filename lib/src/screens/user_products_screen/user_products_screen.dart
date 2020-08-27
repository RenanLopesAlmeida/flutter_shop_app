import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/providers/products_provider.dart';
import 'package:shop_app/src/screens/user_products_screen/widgets/user_product_item.dart';
import 'package:shop_app/src/shared/widgets/app_drawer_widget.dart';

class UserProductsScreen extends StatelessWidget {
  Future<void> deleteProduct(BuildContext context, String id) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .deleteProduct(id);
    return null;
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<ProductsProvider>(
                      builder: (context, productsData, _) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: productsData.products.length,
                            itemBuilder: (context, index) => UserProductItem(
                              id: productsData.products[index].id,
                              title: productsData.products[index].title,
                              imageUrl: productsData.products[index].imageUrl,
                              deleteProduct: deleteProduct,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
