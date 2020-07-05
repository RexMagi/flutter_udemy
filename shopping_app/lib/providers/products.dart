import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_app/models/http_exception.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final _baseUrl =
      'https://udemyfluttershopapp-4de0b.firebaseio.com/products.json';
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    final resp = await http.get(_baseUrl);
    final respBody = json.decode(resp.body) as Map<String, dynamic>;
    final List<Product> loadedProducts = [];
    if (respBody != null) {
      respBody.forEach((prodId, prodData) {
        loadedProducts.add(new Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite']));
      });
    }
    _items = loadedProducts;
    notifyListeners();
  }

  Future<void> addProduct(Product item) async {
    final resp = await http.post(_baseUrl,
        body: json.encode({
          'title': item.title,
          'description': item.description,
          'imageUrl': item.imageUrl,
          'price': item.price,
          'isFavorite': item.isFavorite,
        }));
    final respBody = json.decode(resp.body);
    final newProduct = new Product(
      id: respBody['name'],
      description: item.description,
      imageUrl: item.imageUrl,
      price: item.price,
      title: item.title,
      isFavorite: item.isFavorite,
    );
    items.add(newProduct);
    notifyListeners();
  }

  Product findById(String productId) {
    return items.firstWhere((product) => product.id == productId);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((product) => product.id == id);
    if (productIndex >= 0) {
      final url =
          'https://udemyfluttershopapp-4de0b.firebaseio.com/products/$id.json';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[productIndex] = newProduct;
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://udemyfluttershopapp-4de0b.firebaseio.com/products/$id.json';
    final existingProductIdx = _items.indexWhere((product) => product.id == id);
    final existingProduct = _items[existingProductIdx];
    _items.removeAt(existingProductIdx);
    notifyListeners();
    final resp = await http.delete(url);
    if (resp.statusCode >= 400) {
      _items.insert(existingProductIdx, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
  }
}
