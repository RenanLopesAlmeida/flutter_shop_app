import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop_app/src/config/services/api.dart';
import 'package:shop_app/src/models/order_model.dart';
import 'package:shop_app/src/providers/cart_provider.dart';

import 'package:http/http.dart' as http;

class OrdersProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  final String authToken;
  final String userId;

  OrdersProvider(this.authToken, this.userId, this._orders);

  List<OrderModel> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final _url = '${API.BASE_URL}order/$userId.json?auth=$authToken';
    final response = await http.get(_url);
    final List<OrderModel> loadedOrders = [];
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;

    if (extractedData == null) {
      return;
    }

    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderModel(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });

    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();
    try {
      final _url = '${API.BASE_URL}order/$userId.json?auth=$authToken';
      final response = await http.post(_url,
          body: jsonEncode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartProducts
                .map(
                  (item) => {
                    'id': item.id,
                    'title': item.title,
                    'quantity': item.quantity,
                    'price': item.price,
                  },
                )
                .toList(),
          }));

      _orders.insert(
        0,
        OrderModel(
          id: jsonDecode(response.body)['name'],
          amount: total,
          dateTime: timestamp,
          products: cartProducts,
        ),
      );

      notifyListeners();
    } catch (error) {
      print('Something went wrong in your order request');
    }
  }
}
