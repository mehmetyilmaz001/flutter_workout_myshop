import 'package:flutter/material.dart';
import 'package:flutter_workout_myshop/providers/products.dart';
import 'package:flutter_workout_myshop/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductListItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductListItem(this.title, this.imageUrl, this.id);
  @override
  Widget build(BuildContext context) {
    final scafold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                },
                color: Theme.of(context).primaryColor),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context).deleteProduct(id);
                } catch (err) {
                  scafold.showSnackBar(
                      SnackBar(content: Text('Deleting failed!')));
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
