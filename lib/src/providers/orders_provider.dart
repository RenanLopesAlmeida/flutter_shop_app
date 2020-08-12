import 'package:flutter/foundation.dart';
import 'package:shop_app/src/models/order_model.dart';
import 'package:shop_app/src/providers/cart_provider.dart';

class OrdersProvider with ChangeNotifier {
  List<OrderModel> _orders = [];

  List<OrderModel> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderModel(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );

    notifyListeners();
  }
}
