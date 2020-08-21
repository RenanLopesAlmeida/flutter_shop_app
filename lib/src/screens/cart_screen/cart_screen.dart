import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/providers/cart_provider.dart';
import 'package:shop_app/src/screens/cart_screen/widgets/cart_item.dart';
import 'package:shop_app/src/screens/cart_screen/widgets/order_button.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).accentColor,
                    label: Text(
                      '\$${_cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                  ),
                  OrderButton(cart: _cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _cart.items.length,
              itemBuilder: (_, index) => CartItemWidget(
                id: _cart.items.values.toList()[index].id,
                productId: _cart.items.keys.toList()[index],
                title: _cart.items.values.toList()[index].title,
                price: _cart.items.values.toList()[index].price,
                quantity: _cart.items.values.toList()[index].quantity,
              ),
            ),
          )
        ],
      ),
    );
  }
}
