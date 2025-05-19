// lib/screens/recipe_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../models/ingredient_model.dart';
import '../models/instruction_model.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- MODIFICAÇÃO AQUI ---
            // Só exibe a seção da imagem se imageUrl não for nulo e não estiver vazio
            if (recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  recipe.imageUrl!,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    // Se houver um erro ao carregar uma URL válida,
                    // podemos optar por não mostrar nada ou um ícone discreto.
                    // Por ora, vamos ocultar também em caso de erro de carregamento,
                    // seguindo a lógica de "não mostrar se não estiver disponível".
                    return const SizedBox.shrink(); // Não ocupa espaço
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              // Espaçamento após a imagem, se ela for exibida
            ],
            // --- FIM DA MODIFICAÇÃO ---

            Text(
              recipe.description,
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium,
            ),
            const SizedBox(height: 16.0),

            Row(
              children: [
                const Icon(
                    Icons.timer_outlined, size: 20.0, color: Colors.grey),
                const SizedBox(width: 8.0),
                Text(
                  '${recipe.cookingTimeMinutes} minutos',
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleSmall,
                ),
              ],
            ),
            const Divider(height: 32.0),

            Text(
              'Ingredientes',
              style: Theme
                  .of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12.0),
            _buildIngredientList(recipe.ingredients),
            const Divider(height: 32.0),

            Text(
              'Modo de Preparo',
              style: Theme
                  .of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12.0),
            _buildInstructionList(recipe.instructions),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientList(List<Ingredient> ingredients) {
    if (ingredients.isEmpty) {
      return const Text('Nenhum ingrediente listado.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredients.map((ingredient) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• ',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              Expanded(
                child: Text(
                  '${ingredient.quantity} ${ingredient.name}',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInstructionList(List<Instruction> instructions) {
    if (instructions.isEmpty) {
      return const Text('Nenhuma instrução fornecida.');
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: instructions.length,
      itemBuilder: (context, index) {
        final instruction = instructions[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${instruction.order}. ',
                style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Text(
                  instruction.description,
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge,
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8.0),
    );
  }
}