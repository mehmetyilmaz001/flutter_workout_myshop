import 'package:flutter/material.dart';
import 'package:flutter_workout_myshop/providers/orders.dart';
import 'package:flutter_workout_myshop/widgets/app_drawer.dart';
import 'package:flutter_workout_myshop/widgets/order_list_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                return Center(child: Text('Error Oucured!'),);
              } else {
                return Consumer<Orders>(builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderListItem(orderData.orders[i]),
                ));
              }
            }
          },
        ));
  }
}
