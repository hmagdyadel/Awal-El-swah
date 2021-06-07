import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/cart.dart';
import 'package:flutter/material.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  String? authToken;
  String? userId;

  getData(String? token, String? uId, List<OrderItem> orders) {
    authToken = token;
    userId = uId;
    _orders = orders;
    notifyListeners();
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://awal-elswah-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final res = await http.get(Uri.parse(url));
      final Map<String, dynamic>? extractedData =
          json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ))
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime']),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url =
        'https://awal-elswah-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final timestamp = DateTime.now();
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartProduct
                .map((cartPro) => {
                      'id': cartPro.id,
                      'title': cartPro.title,
                      'quantity': cartPro.quantity,
                      'price': cartPro.price
                    })
                .toList(),
          }));
      _orders.insert(
          0,
          OrderItem(
              id: json.decode(res.body)['name'],
              amount: total,
              products: cartProduct,
              dateTime: timestamp));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
