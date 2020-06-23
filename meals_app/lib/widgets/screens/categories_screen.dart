import 'package:flutter/material.dart';
import 'package:meals_app/widgets/components/categories_item.dart';
import 'package:meals_app/widgets/dummy_data.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(25),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: <Widget>[
        ...DUMMY_CATEGORIES.map((e) {
          return CategoriesItem(
            key: ValueKey(e.id),
            title: e.title,
            color: e.color,
            id: e.id,
          );
        }).toList(),
      ],
    );
  }
}
