import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite; // This field will be changed at runtime.

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  void _setFavVlue(bool value) {
    isFavorite = value;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = 'https://flutter-test-shopapp.firebaseio.com/products/$id.json';
    try {
      final res =
          await http.patch(url, body: json.encode({'isFavorite': isFavorite}));
      if (res.statusCode >= 400) {
        _setFavVlue(oldStatus);
      }
    } catch (err) {
      _setFavVlue(oldStatus);
    }
  }
}
