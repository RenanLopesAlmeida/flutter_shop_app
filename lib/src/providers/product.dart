import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/src/config/services/api.dart';
import 'package:shop_app/src/shared/exceptions/http_exception.dart';

class Product with ChangeNotifier {
  final String id, title, description, imageUrl;
  final double price;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false,
  });

  void _setFavoriteValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
    HttpException('Could not update favorite');
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final _url = '${API.BASE_URL}products/$id.json';

    try {
      final response =
          await http.patch(_url, body: jsonEncode({'isFavorite': isFavorite}));

      if (response.statusCode >= 400) {
        _setFavoriteValue(oldStatus);
      }
    } catch (error) {
      _setFavoriteValue(oldStatus);
    }
  }
}
