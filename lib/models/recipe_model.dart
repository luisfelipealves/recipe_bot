// lib/models/recipe_model.dart

import 'ingredient_model.dart';
import 'instruction_model.dart';

class Recipe {
  final String id;
  final String title;
  final String description;
  final int cookingTimeMinutes;
  final String? imageUrl;
  final List<Ingredient> ingredients;
  final List<Instruction> instructions;
  final String? sourceUrl;
  final int? servings;
  final String? notes;
  final List<String>? tags;
  final bool isFavorite; // Default this in constructor

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.cookingTimeMinutes,
    this.imageUrl,
    required this.ingredients,
    required this.instructions,
    this.sourceUrl,
    this.servings,
    this.notes,
    this.tags,
    this.isFavorite = false, // Default value
  });
}