import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/providers/cart_provider.dart';
import 'package:shop_app/src/providers/products_provider.dart';

class CartItemWidget extends StatelessWidget {
  final String id, productId, title;
  final double price;
  final int quantity;

  const CartItemWidget({
    this.id,
    this.productId,
    this.title,
    this.price,
    this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final _cart = Provider.of<CartProvider>(context, listen: false);
    final _productImageUrl =
        Provider.of<ProductsProvider>(context, listen: false)
            .getProductImageUrl(productId);

    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        _cart.removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure ?'),
            content: Text('Do you want to remove this item from the cart?'),
            actions: <Widget>[
              FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  }),
              FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  }),
            ],
          ),
        );
      },
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 35,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  _productImageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Subtotal: \$${(price * quantity)}'),
            trailing: Text('$quantity X $price'),
          ),
        ),
      ),
    );
  }
}
