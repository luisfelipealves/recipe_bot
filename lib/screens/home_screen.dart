// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import 'login_screen.dart';
import 'import_recipe_screen.dart';
import '../widgets/recipe_list.dart';
import '../widgets/empty_state_widget.dart'; // Importe o EmptyStateWidget
import '../data/mock_recipes.dart';
import '../models/recipe_model.dart';

// import 'package:logger/logger.dart';
// final logger = Logger();

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await AuthService().signOut();
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
      );
    } catch (e, stackTrace) {
      // logger.e("Erro ao fazer logout", error: e, stackTrace: stackTrace);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Erro ao fazer logout: ${e.toString()}')),
      );
    }
  }

  void _navigateToImportRecipeScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ImportRecipeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Para testar o estado vazio:
    // final List<Recipe> currentRecipes = [];
    final List<Recipe> currentRecipes = mockRecipes; // Use para testar com receitas

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Bot'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Sair',
              onPressed: () => _signOut(context),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                const Icon(
                  Icons.menu_book,
                  size: 28.0,
                  color: Colors.teal,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Meu Livro de Receitas',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              'Suas receitas salvas, ordenadas alfabeticamente. Clique para ver os detalhes ou adicione novas receitas.',
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
            ),
            const SizedBox(height: 20.0),

            // LÓGICA PARA MOSTRAR EMPTY STATE OU LISTA DE RECEITAS
            Expanded(
              child: currentRecipes.isEmpty
                  ? EmptyStateWidget(
                iconData: Icons.ramen_dining_outlined,
                title: 'Seu Livro de Receitas Está Vazio',
                message: 'Que tal adicionar sua primeira obra-prima culinária?',
                // Se quiser um botão de ação aqui, que faz o mesmo que o FAB:
                actionButtonText: 'Adicionar Receita',
                onActionButtonPressed: () =>
                    _navigateToImportRecipeScreen(context),
              )
                  : RecipeList(
                recipes: currentRecipes,
                // Se o RecipeList tivesse um botão interno de adicionar, você passaria a função aqui.
                // Mas com o EmptyStateWidget tendo o seu, pode não ser necessário no RecipeList.
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToImportRecipeScreen(context),
        tooltip: 'Importar Receita',
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('Importar Receita'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}