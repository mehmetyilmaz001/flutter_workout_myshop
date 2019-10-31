import 'package:flutter/material.dart';
import 'package:flutter_workout_myshop/providers/orders.dart';
import 'package:flutter_workout_myshop/widgets/app_drawer.dart';
import 'package:flutter_workout_myshop/widgets/order_list_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = false;
 
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();

      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, i) => OrderListItem(orderData.orders[i]),
      ),
    );
  }
}
