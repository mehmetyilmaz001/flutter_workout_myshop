import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount{
    return _items == null ? 0 : _items.length;
  }

  double get totalAmount{
    var total = 0.0;
    _items.forEach((key,item){
      total += item.price * item.quantity;
    } );

    return total;
  }


  void removeItem(String id){
    _items.remove(id);
    notifyListeners();
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      //Increment qauntity
      _items.update(
          productId,
          (existing) => CartItem(
              id: existing.id,
              title: existing.title,
              price: existing.price,
              quantity: existing.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              price: price,
              title: title,
              quantity: 1));
    }

    notifyListeners();
  }
}
