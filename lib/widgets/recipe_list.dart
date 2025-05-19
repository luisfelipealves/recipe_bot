// lib/widgets/recipe_list.dart
import 'package:flutter/material.dart';
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
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            leading:
            // Esta condição agora é perfeitamente adequada para imageUrl?
            recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty // O '!' aqui é seguro devido à verificação anterior
                ? SizedBox(
              width: 60,
              height: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  recipe.imageUrl!, // '!' é seguro aqui
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported, size: 40);
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator(strokeWidth: 2.0));
                  },
                ),
              ),
            )
                : const SizedBox(
              width: 60,
              height: 60,
              child: Icon(Icons.restaurant_menu, size: 40),
            ),
            title: Text(recipe.title, style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(
              recipe.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
            onTap: () {
              print('Clicou em: ${recipe.title}');
              // Exemplo: Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeDetailScreen(recipe: recipe)));
            },
          ),
        );
      },
    );
  }
}