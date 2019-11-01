import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_workout_myshop/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime,
      });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://flutter-test-shopapp.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final res = await http.get(url);
      final List<OrderItem> loadedOrders = [];
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((orderId, item) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: item['amount'],
            dateTime: DateTime.parse(item['dateTime']),
            products: (item['products'] as List<dynamic>).map((item) =>
                CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title']
                  )
              ).toList()
            )
          );
      });

      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://flutter-test-shopapp.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();

    try {
      final res = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartProducts
                .map((item) => {
                      'id': item.id,
                      'title': item.title,
                      'quantity': item.quantity,
                      'price': item.price
                    })
                .toList()
          }));
      print(json.decode(res.body));
      _orders.insert(
          0,
          OrderItem(
              id: json.decode(res.body)['name'],
              amount: total,
              dateTime: timestamp,
              products: cartProducts));

      notifyListeners();
    } catch (err) {
      print(err);
      throw (err);
    }
  }
}
