import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/providers/cart_provider.dart';
import 'package:shop_app/src/providers/product.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _product = Provider.of<Product>(context, listen: false);
    final _cart = Provider.of<CartProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/product-detail-screen',
              arguments: _product.id,
            );
          },
          child: Container(
            constraints: BoxConstraints(maxHeight: 200, maxWidth: 200),
            child: Image.network(
              _product.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () {
                product.toggleFavoriteStatus();
              },
            ),
          ),
          title: Text(
            _product.title,
            textAlign: TextAlign.center,
          ),
          trailing: Container(
            child: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                _cart.addItem(_product.id, _product.title, _product.price);
              },
            ),
          ),
        ),
      ),
    );
  }
}
