import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/src/config/services/api.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/src/shared/exceptions/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  String _signUpURL = API.AUTH_SIGN_UP_URL;
  String _signInURL = API.AUTH_SIGN_IN_URL;

  bool get isAuth {
    return (token != null);
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  Future<void> _authenticate(
      String email, String password, String authURL) async {
    try {
      final response = await http.post(authURL,
          body: jsonEncode(
            {
              'email': email,
              'password': password,
              'returnSecureToken': true,
            },
          ));

      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, _signUpURL);
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, _signInURL);
  }
}
