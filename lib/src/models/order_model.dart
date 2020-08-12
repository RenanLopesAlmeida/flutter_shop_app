import 'package:flutter/foundation.dart';
import 'package:shop_app/src/providers/cart_provider.dart';

class OrderModel {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderModel({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}
