import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/providers/orders_provider.dart';
import 'package:shop_app/src/screens/orders_screen/widgets/order_item.dart';
import 'package:shop_app/src/shared/widgets/app_drawer_widget.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _ordersData = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: _ordersData.orders.length,
        itemBuilder: (_, index) => OrderItem(
          orderItem: _ordersData.orders[index],
        ),
      ),
    );
  }
}
