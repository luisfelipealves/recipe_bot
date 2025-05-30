// lib/services/recipe_extraction_service.dart
import 'dart:async';

import 'package:recipe_bot/models/ingredient_model.dart';
import 'package:recipe_bot/models/instruction_model.dart';
import 'package:recipe_bot/models/recipe_model.dart';

Future<Recipe> extractRecipeFromUrl(String url) async {
  // Simulate network delay
  await Future.delayed(const Duration(seconds: 2));

  if (url.toLowerCase().contains('recipe')) {
    // Create mock ingredients
    final mockIngredients = [
      Ingredient(order: 1, name: 'All-purpose flour', quantity: '2 cups'),
      Ingredient(order: 2, name: 'Sugar', quantity: '1 cup'),
      Ingredient(order: 3, name: 'Eggs', quantity: '3'),
      Ingredient(order: 4, name: 'Milk', quantity: '1/2 cup'),
      Ingredient(order: 5, name: 'Butter', quantity: '100g'),
    ];

    // Create mock instructions
    final mockInstructions = [
      Instruction(order: 1, description: 'Preheat oven to 180°C (350°F).'),
      Instruction(order: 2, description: 'In a large bowl, mix flour and sugar.'),
      Instruction(order: 3, description: 'Add eggs one at a time, beating well after each addition.'),
      Instruction(order: 4, description: 'Gradually add milk and melted butter, mixing until smooth.'),
      Instruction(order: 5, description: 'Pour batter into a greased baking pan.'),
      Instruction(order: 6, description: 'Bake for 30-35 minutes, or until a toothpick inserted into the center comes out clean.'),
    ];

    // Create and return a dummy Recipe object
    return Recipe(
      id: 'dummy-${DateTime.now().millisecondsSinceEpoch}', // Unique dummy ID
      title: 'Sample Recipe Cake',
      description: 'A delicious and easy-to-make sample cake recipe, perfect for beginners.',
      sourceUrl: url,
      cookingTimeMinutes: 45,
      servings: 8,
      ingredients: mockIngredients,
      instructions: mockInstructions,
      notes: 'You can add chocolate chips or nuts to the batter for extra flavor.',
      tags: ['cake', 'dessert', 'baking', 'easy'],
      isFavorite: false,
      // Assuming default values for createdAt and updatedAt, or they can be set here
      // createdAt: DateTime.now(),
      // updatedAt: DateTime.now(),
    );
  } else {
    throw Exception('Invalid recipe URL: Must contain the word "recipe".');
  }
}
