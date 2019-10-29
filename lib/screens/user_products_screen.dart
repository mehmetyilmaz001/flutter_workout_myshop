import 'package:flutter/material.dart';
import 'package:flutter_workout_myshop/providers/products.dart';
import 'package:flutter_workout_myshop/screens/edit_product.screen.dart';
import 'package:flutter_workout_myshop/widgets/app_drawer.dart';
import 'package:flutter_workout_myshop/widgets/user_product_list_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (ctx, i) => Column(
            children: <Widget>[
              UserProductListItem(
                  productsData.items[i].title, productsData.items[i].imageUrl),
                  Divider()
            ],
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}