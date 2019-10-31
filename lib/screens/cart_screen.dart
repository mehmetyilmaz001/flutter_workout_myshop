import 'package:flutter/material.dart';
import 'package:flutter_workout_myshop/providers/cart.dart' show Cart;
import 'package:flutter_workout_myshop/providers/orders.dart';
import 'package:provider/provider.dart';
import 'package:flutter_workout_myshop/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: <Widget>[
          TotalCard(cart: cart),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) {
                var cartItem = cart.items.values.toList()[i];
                return CartItem(
                  id: cartItem.id,
                  productId: cart.items.keys.toList()[i],
                  price: cartItem.price,
                  quantity: cartItem.quantity,
                  title: cartItem.title,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class TotalCard extends StatefulWidget {
  const TotalCard({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _TotalCardState createState() => _TotalCardState();
}

class _TotalCardState extends State<TotalCard> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15),
      child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Total',
                style: TextStyle(fontSize: 20),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '\$${widget.cart.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                      color: Theme.of(context).primaryTextTheme.title.color),
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              FlatButton(
                child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
                onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
                    ? null
                    : () async {
                        
                        setState(() {
                          _isLoading = true;
                        });

                        await Provider.of<Orders>(context, listen: false)
                            .addOrder(widget.cart.items.values.toList(),
                                widget.cart.totalAmount);
                        setState(() {
                          _isLoading = false;
                        });
                        widget.cart.clear();
                      },
                textColor: Theme.of(context).primaryColor,
              )
            ],
          )),
    );
  }
}
