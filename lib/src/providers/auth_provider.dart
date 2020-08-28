import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/src/config/services/api.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/src/shared/exceptions/http_exception.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  String _signUpURL = API.AUTH_SIGN_UP_URL;
  String _signInURL = API.AUTH_SIGN_IN_URL;

  bool get isAuth {
    return (token != null);
  }

  String get userId => _userId;

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
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(responseData['expiresIn'])),
      );

      _autoLogout();
      notifyListeners();
      _persistUserData();
    } catch (error) {
      throw error;
    }
  }

  Future<void> _persistUserData() async {
    final preferences = await SharedPreferences.getInstance();
    final userData = jsonEncode({
      'token': _token,
      'userId': _userId,
      'expiryData': _expiryDate.toIso8601String(),
    });

    preferences.setString('userData', userData);
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, _signUpURL);
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, _signInURL);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        jsonDecode(prefs.getString('userData')) as Map<String, Object>;

    final expiryDate = DateTime.parse(extractedUserData['expiryData']);

    // Invalid Token
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;

    notifyListeners();
    _autoLogout();
    return true;
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;

    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
