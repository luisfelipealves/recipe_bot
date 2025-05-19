// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import 'login_screen.dart';
import 'import_recipe_screen.dart';
import '../widgets/recipe_list.dart'; // Importe o novo widget
import '../data/mock_recipes.dart'; // Importe os dados mock

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
    } catch (e) {
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
        // Removido padding inferior para a lista preencher
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Icon(
                  Icons.menu_book,
                  size: 28.0,
                  color: Colors.teal, // Cor teal no ícone
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

            // Use o widget RecipeList aqui
            Expanded( // Expanded é importante para que o ListView ocupe o espaço restante
              child: RecipeList(recipes: mockRecipes),
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