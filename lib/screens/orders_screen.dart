import 'package:flutter/material.dart';
import 'package:flutter_workout_myshop/providers/orders.dart';
import 'package:flutter_workout_myshop/widgets/app_drawer.dart';
import 'package:flutter_workout_myshop/widgets/order_list_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const roueteName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, i) => OrderListItem(orderData.orders[i]),
      ),
    );
  }
}
