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
            // Imagem da Receita (se houver)
            if (recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty)
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
                    return SizedBox(
                      height: 250,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.broken_image, size: 50),
                            const SizedBox(height: 8),
                            Text('Imagem não disponível', style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty)
              const SizedBox(height: 20.0),

            // Título da Receita (redundante se já estiver no AppBar, mas pode ser estilizado aqui)
            // Text(
            //   recipe.title,
            //   style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 8.0),

            // Descrição
            Text(
              recipe.description,
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium,
            ),
            const SizedBox(height: 16.0),

            // Tempo de Preparo
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

            // Seção de Ingredientes
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

            // Seção de Instruções
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
            // Espaço no final
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientList(List<Ingredient> ingredients) {
    if (ingredients.isEmpty) {
      return const Text('Nenhum ingrediente listado.');
    }
    // Usando ListView.builder dentro de Column pode causar problemas de altura.
    // Para listas pequenas e não roláveis dentro de outra rolagem, Column é aceitável.
    // Se a lista de ingredientes for muito longa, considere outras abordagens.
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
      // Importante para ListView dentro de SingleChildScrollView
      physics: const NeverScrollableScrollPhysics(),
      // Desabilita rolagem própria do ListView
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