import 'package:flutter/material.dart';
import 'package:flutter_workout_myshop/providers/cart.dart';
import 'package:flutter_workout_myshop/providers/products.dart';
import 'package:flutter_workout_myshop/screens/cart_screen.dart';
import 'package:flutter_workout_myshop/widgets/app_drawer.dart';
import 'package:flutter_workout_myshop/widgets/badge.dart';
import 'package:flutter_workout_myshop/widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/products-overview';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorite = false;
  bool _isInit = true;
  bool _isloading = false;

  @override
  void initState() {
    super.initState();

    //Provider.of<Products>(context).fetchAndSetProducts(); // there is no context in init state so wont work

    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      setState(() {
        _isloading = true;  
      });
      
      Provider.of<Products>(context).fetchAndSetProducts().then((_){
        setState(() {
            _isloading = false;
        });
      });
    }

    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MyShop'),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    _showOnlyFavorite = true;
                  } else {
                    _showOnlyFavorite = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.Favorites,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.All,
                ),
              ],
            ),
            Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                child: ch,
                value: cart.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: _isloading ? Center(child: CircularProgressIndicator(),) : ProductsGrid(_showOnlyFavorite));
  }
}
