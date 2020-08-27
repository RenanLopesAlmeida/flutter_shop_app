import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/providers/orders_provider.dart';
import 'package:shop_app/src/screens/orders_screen/widgets/order_item.dart';
import 'package:shop_app/src/shared/widgets/app_drawer_widget.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future:
            Provider.of<OrdersProvider>(context, listen: false).fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data != null) {
              return Center(child: Text('An error has occurred'));
            } else {
              return Consumer<OrdersProvider>(
                builder: (ctx, ordersData, child) {
                  return ListView.builder(
                    itemCount: ordersData.orders.length,
                    itemBuilder: (_, index) => OrderItem(
                      orderItem: ordersData.orders[index],
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
