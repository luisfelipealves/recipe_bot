// lib/widgets/recipe_list.dart
import 'package:flutter/material.dart';
import 'package:recipe_bot/widgets/recipe_list_item.dart.dart';
import '../models/recipe_model.dart';

class RecipeList extends StatelessWidget {
  final List<Recipe> recipes;

  const RecipeList({
    super.key,
    required this.recipes,
  });

  @override
  Widget build(BuildContext context) {
    if (recipes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Nenhuma receita cadastrada ainda.\nToque no botão "+" para adicionar sua primeira receita!',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return RecipeListItem(recipe: recipe);
      },
    );
  }
}