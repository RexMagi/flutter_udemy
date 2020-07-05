import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus() async {
    final url =
        'https://udemyfluttershopapp-4de0b.firebaseio.com/products/$id.json';
    this.isFavorite = !this.isFavorite;
    this.notifyListeners();
    try {
      final resp = await http.patch(url,
          body: json.encode({
            isFavorite: isFavorite,
          }));
      if (resp.statusCode >= 400) {
        isFavorite = !isFavorite;
        this.notifyListeners();
      }
    } catch (e) {
      isFavorite = !isFavorite;
      this.notifyListeners();
    }
  }
}
