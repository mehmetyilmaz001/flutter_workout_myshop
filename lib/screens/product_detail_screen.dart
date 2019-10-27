import 'package:flutter/material.dart';
import 'package:flutter_workout_myshop/providers/products.dart';
import 'package:provider/provider.dart';
 
class ProductDetailScreen extends StatelessWidget {
  // final String title;

  // ProductDetailScreen(this.title);

  static const routePath = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(context).findById(productId);
    return Scaffold(
        appBar: AppBar(
          title: Text(product.title),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
      
    );
  }
}