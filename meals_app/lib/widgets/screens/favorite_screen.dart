import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/widgets/components/meal_item.dart';

class FavoriteScreen extends StatelessWidget {
  final List<Meal> _favoriteMeals;

  const FavoriteScreen(this._favoriteMeals);

  @override
  Widget build(BuildContext context) {
    if (_favoriteMeals.isEmpty) {
      return Center(
        child: Text('You have no favorites yet - start adding some!'),
      );
    }
    return ListView.builder(
      itemBuilder: (ctx, idx) {
        var meal = _favoriteMeals[idx];
        return MealItem(
          key: ValueKey(meal.id),
          id: meal.id,
          title: meal.title,
          imageUrl: meal.imageUrl,
          duration: meal.duration,
          complexity: meal.complexity,
          affordability: meal.affordability,
        );
      },
      itemCount: _favoriteMeals.length,
    );
  }
}
