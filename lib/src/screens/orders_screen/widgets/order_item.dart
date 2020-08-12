import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/src/models/order_model.dart';

class OrderItem extends StatelessWidget {
  final OrderModel orderItem;

  const OrderItem({this.orderItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$ ${orderItem.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(orderItem.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
