// lib/widgets/recipe_list_item.dart
import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../screens/recipe_detail_screen.dart'; // 1. Importe a nova tela

class RecipeListItem extends StatelessWidget {
  final Recipe recipe;

  const RecipeListItem({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        leading: recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty
            ? SizedBox(
          width: 60,
          height: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              recipe.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  width: 60,
                  height: 60,
                  child: Icon(Icons.restaurant_menu, size: 40),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2.0));
              },
            ),
          ),
        )
            : const SizedBox(
          width: 60,
          height: 60,
          child: Icon(Icons.restaurant_menu, size: 40),
        ),
        title: Text(recipe.title,
            style: Theme
                .of(context)
                .textTheme
                .titleMedium),
        subtitle: Text(
          recipe.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
        onTap: () {
          // 2. Navegue para RecipeDetailScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(recipe: recipe),
            ),
          );
        },
      ),
    );
  }
}