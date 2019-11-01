import 'package:flutter/material.dart';
import 'package:flutter_workout_myshop/providers/auth.dart';
import 'package:flutter_workout_myshop/providers/cart.dart';
import 'package:flutter_workout_myshop/providers/orders.dart';
import 'package:flutter_workout_myshop/screens/auth-screen.dart';
import 'package:flutter_workout_myshop/screens/cart_screen.dart';
import 'package:flutter_workout_myshop/screens/edit_product.screen.dart';
import 'package:flutter_workout_myshop/screens/orders_screen.dart';
import 'package:flutter_workout_myshop/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

import 'package:flutter_workout_myshop/screens/product_detail_screen.dart';
import 'package:flutter_workout_myshop/screens/products_overview_screen.dart';
import './providers/products.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ProxyProvider<Auth, Products>(
          builder: (ctx, auth, prevProducts) => Products(
              auth.token, auth.userId, prevProducts == null ? [] : prevProducts.items),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ProxyProvider<Auth, Orders>(
          builder: (ctx, auth, prevOrders) =>
              Orders(auth.token, auth.userId, prevOrders == null ? [] : prevOrders.orders),
        )
      ],
      child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                    primarySwatch: Colors.purple,
                    accentColor: Colors.deepOrange),
                home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
                routes: {
                  ProductsOverviewScreen.routePath: (ctx) =>
                      ProductsOverviewScreen(),
                  ProductDetailScreen.routePath: (ctx) => ProductDetailScreen(),
                  CartScreen.routeName: (ctx) => CartScreen(),
                  OrdersScreen.routeName: (ctx) => OrdersScreen(),
                  UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                  EditProductScreen.routeName: (ctx) => EditProductScreen()
                },
              )),
    );
  }
}


