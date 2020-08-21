import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/providers/cart_provider.dart';
import 'package:shop_app/src/providers/orders_provider.dart';

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required CartProvider cart,
  })  : _cart = cart,
        super(key: key);

  final CartProvider _cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  void _handleOrder() async {
    setState(() {
      _isLoading = true;
    });

    if (widget._cart.totalAmount > 0) {
      await Provider.of<OrdersProvider>(context, listen: false).addOrder(
        widget._cart.items.values.toList(),
        widget._cart.totalAmount,
      );

      setState(() {
        _isLoading = false;
      });

      widget._cart.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: (_isLoading)
          ? CircularProgressIndicator()
          : Text(
              'ORDER NOW',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
      textColor: Theme.of(context).primaryColor,
      onPressed: (widget._cart.totalAmount <= 0 || _isLoading)
          ? null
          : this._handleOrder,
    );
  }
}
