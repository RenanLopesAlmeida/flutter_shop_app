import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/providers/cart_provider.dart';
import 'package:shop_app/src/providers/products_provider.dart';
import 'package:shop_app/src/screens/products_overview_screen/widgets/products_grid.dart';
import 'package:shop_app/src/shared/widgets/app_drawer_widget.dart';
import 'package:shop_app/src/shared/widgets/badge_widget.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.Favorites),
              PopupMenuItem(
                  child: Text('Select All'), value: FilterOptions.All),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
          ),
          Consumer<CartProvider>(
            builder: (_, cart, child) => Badge(
              value: cart.itemCount.toString(),
              child: child,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, '/cart-screen');
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<ProductsProvider>(
          context,
          listen: false,
        ).fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.error != null) {
            return Center(
              child: Text(
                  'Something went wrong, check your internet connection and try again'),
            );
          } else {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ProductsGrid(
                showFavorites: _showOnlyFavorites,
              );
            }
          }
        },
      ),
    );
  }
}
