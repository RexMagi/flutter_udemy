import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shopping_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final baseUrl =
        'https://udemyfluttershopapp-4de0b.firebaseio.com/orders.json';
    final resp = await get(baseUrl);
    final List<OrderItem> loadedOrderItems = [];
    final respBody = json.decode(resp.body) as Map<String, dynamic>;
    if (respBody != null) {
      respBody.forEach((orderId, orderData) {
        loadedOrderItems.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((ci) => CartItem(
                    id: ci['id'],
                    title: ci['title'],
                    quantity: ci['quantity'],
                    price: ci['price'],
                  ))
              .toList(),
          dateTime: DateTime(orderData['dateTime']),
        ));
      });
    }
    _orders = loadedOrderItems.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final baseUrl =
        'https://udemyfluttershopapp-4de0b.firebaseio.com/orders.json';
    final timestamp = DateTime.now();
    final resp = await post(baseUrl,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList()
        }));
    final respBody = json.decode(resp.body);
    _orders.insert(
        0,
        OrderItem(
          id: respBody['name'],
          amount: total,
          dateTime: timestamp,
          products: cartProducts,
        ));
    notifyListeners();
  }
}
