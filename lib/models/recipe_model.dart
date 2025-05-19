// lib/models/recipe_model.dart

class Recipe {
  final String id;
  final String title;
  final String description;
  final int cookingTimeMinutes;
  final String? imageUrl; // <--- TORNE ANULÁVEL COM '?'

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.cookingTimeMinutes,
    this.imageUrl, // <--- imageUrl agora é opcional no construtor
  });
}