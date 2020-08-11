import 'package:flutter/material.dart';

class CartItemWidget extends StatelessWidget {
  final String id, title;
  final double price;
  final int quantity;

  const CartItemWidget({this.id, this.title, this.price, this.quantity});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(10),
            child: FittedBox(child: Text('\$ $price')),
          ),
          title: Text(title),
          subtitle: Text('Subtotal: \$${(price * quantity)}'),
          trailing: Text('$quantity X'),
        ),
      ),
    );
  }
}
