import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products.dart';
import 'package:shopping_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem({
    Key key,
    this.id,
    this.title,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
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
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: id,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () async {
                try {
                  Provider.of<Products>(
                    context,
                    listen: false,
                  ).deleteProduct(id);
                } catch (e) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Deleteing product faild.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
