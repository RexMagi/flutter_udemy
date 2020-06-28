import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products.dart';

import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool _showFavorites;

  const ProductsGrid(this._showFavorites);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products =
        _showFavorites ? productData.favoriteItems : productData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ChangeNotifierProvider.value(
          key: ValueKey(product.id),
          value: product,
          child: ProductItem(),
        );
      },
      itemCount: products.length,
    );
  }
}
