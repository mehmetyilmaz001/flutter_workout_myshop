import 'package:flutter/material.dart';
import 'package:flutter_workout_myshop/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  var _showFavoritesOnly = false;

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://flutter-test-shopapp.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      List<Product> loadedProducts = [];
      data.forEach((id, item) {
        loadedProducts.add(Product(
            id: id,
            title: item['title'],
            description: item['description'],
            price: item['price'],
            imageUrl: item['imageUrl'],
            isFavorite: item['isFavorite']));
      });
      notifyListeners();
      print(json.decode(response.body));

      _items = loadedProducts;
    } catch (err) {
      throw (err);
    }
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://flutter-test-shopapp.firebaseio.com/products.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite
          }));

      print(json.decode(response.body));

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);

      _items.add(newProduct);
      //_items.insert(0, newProduct); // adds the start of the list

      notifyListeners();
    } catch (err) {
      print(err);
      throw (err);
    }
  }

  Future<void> updateProduct(String id, Product updatedProduct) async {
    final itemIndex = _items.indexWhere((item) => item.id == id);

    if (itemIndex >= 0) {
      _items[itemIndex] = updatedProduct;
      final url =
          'https://flutter-test-shopapp.firebaseio.com/products/$id.json';
      await http.patch(url,
          body: json.encode({
            'title': updatedProduct.title,
            'description': updatedProduct.description,
            'imageUrl': updatedProduct.imageUrl,
            'price': updatedProduct.price
          }));
      notifyListeners();
    } else {
      print('Could not find the object to update $id');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://flutter-test-shopapp.firebaseio.com/products/$id.json';

    final exisitingProductIndex = _items.indexWhere((item) => item.id == id);
    var exisitingProduct = _items[exisitingProductIndex];
    _items.removeAt(exisitingProductIndex);

    final res = await http.delete(url);
    notifyListeners();

    if (res.statusCode >= 400) {
      //On error delete method does not go in the catch block. Follow the status code
      //with res.statusCode
      _items.insert(exisitingProductIndex,
          exisitingProduct); //Rollback delete proccess on error
      notifyListeners();
      throw HttpException('Could not delete product!');
    }
    exisitingProduct = null;
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }
}
