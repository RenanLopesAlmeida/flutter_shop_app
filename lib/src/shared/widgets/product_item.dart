import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/providers/auth_provider.dart';
import 'package:shop_app/src/providers/cart_provider.dart';
import 'package:shop_app/src/providers/product.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _product = Provider.of<Product>(context, listen: false);
    final _cart = Provider.of<CartProvider>(context, listen: false);
    final _authData = Provider.of<AuthProvider>(context, listen: false);

    return GridTile(
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
          child: Hero(
            tag: '${_product.id}',
            child: Image.network(
              _product.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      footer: GridTileBar(
        backgroundColor: Color.fromRGBO(204, 204, 204, 0.8),
        leading: Consumer<Product>(
          builder: (ctx, product, _) => IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            onPressed: () {
              product.toggleFavoriteStatus(_authData.token, _authData.userId);
            },
          ),
        ),
        title: Text(
          _product.title,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        trailing: Container(
          child: IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              _cart.addItem(_product.id, _product.title, _product.price);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('added an item to cart'),
                duration: Duration(milliseconds: 1200),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    _cart.removeSingleItem(_product.id);
                  },
                ),
              ));
            },
          ),
        ),
      ),
    );
  }
}
