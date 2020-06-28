import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/cart.dart' show Cart;
import 'package:shopping_app/providers/orders.dart';
import 'package:shopping_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(children: [
        Card(
          margin: const EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsPrecision(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    onPressed: () {
                      Provider.of<Orders>(
                        context,
                        listen: false,
                      ).addOrder(cart.items.values.toList(), cart.totalAmount);
                      cart.clear();
                    },
                    child: Text('ORDER NOW'),
                    textColor: Theme.of(context).primaryColor,
                  )
                ]),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ListView.builder(
            itemCount: cart.count,
            itemBuilder: (context, index) {
              final productId = cart.items.keys.toList()[index];
              final cartItem = cart.items.values.toList()[index];
              return CartItem(
                key: ValueKey(cartItem.id),
                id: cartItem.id,
                productId: productId,
                price: cartItem.price,
                quantity: cartItem.quantity,
                title: cartItem.title,
              );
            },
          ),
        )
      ]),
    );
  }
}
