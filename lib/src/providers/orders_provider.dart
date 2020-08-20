import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop_app/src/config/services/api.dart';
import 'package:shop_app/src/models/order_model.dart';
import 'package:shop_app/src/providers/cart_provider.dart';

import 'package:http/http.dart' as http;

class OrdersProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  final _url = '${API.BASE_URL}order.json';

  List<OrderModel> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final _productEncoded = jsonEncode({});
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
