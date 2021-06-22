import '../models/http_exception.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
//import 'package:firebase_auth/firebase_auth.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    tryAutoLogin();
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCR7Cg1bugqEv9uo9T7-tgndVocX-5iOc8';
    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(res.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      String userData = json.encode({
        'token': _token,
        'userId': _userId,
        "expiryDate": _expiryDate!.toIso8601String(),
      });
      prefs.setString('userData', userData);
      print('the token is:$_token:the end of token');
      print('the user id is:$_userId:the end of user id');
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');

    // try {
    //   UserCredential userCredential =
    //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //     email: email,
    //     password: password,
    //   );
    //   final prefs = await SharedPreferences.getInstance();
    //   String userData = json.encode({
    //     'token': FirebaseAuth.instance.currentUser!.getIdToken().toString(),
    //     'userId': FirebaseAuth.instance.currentUser!.uid.toString(),
    //   });
    //   prefs.setString('userData', userData);
    //   print('done');
    //   print(
    //       'the token is : ${FirebaseAuth.instance.currentUser!.getIdToken().toString()}');
    //   print('the uid is :${FirebaseAuth.instance.currentUser!.uid.toString()}');
    // } catch (e) {
    //   print(e);
    // }
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');

    // try {
    //   UserCredential userCredential =
    //       await FirebaseAuth.instance.signInWithEmailAndPassword(
    //     email: email,
    //     password: password,
    //   );
    //   final user = FirebaseAuth.instance.currentUser!;
    //   final prefs = await SharedPreferences.getInstance();
    //   String userData = json.encode({
    //     'token': user.getIdToken(),
    //     'userId': user.uid,
    //   });
    //   prefs.setString('userData', userData);
    //   print('done');
    //   print('the token is : ${user.getIdToken()}');
    //   print('the uid is :${user.uid}');
    // } catch (e) {
    //   print(e);
    // }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    final extractedData = json.decode(prefs.getString('userData').toString())
        as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return false;
    _token = extractedData['token'].toString();
    _userId = extractedData['userId'].toString();
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
