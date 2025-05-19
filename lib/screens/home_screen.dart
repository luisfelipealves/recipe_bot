// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import 'login_screen.dart';
import 'import_recipe_screen.dart';

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
      body: Padding( // Adiciona padding geral ao body
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinha o conteúdo da Column à esquerda
          children: <Widget>[
            // Título com Ícone
            Row(
              children: [
                const Icon(
                  Icons.menu_book, // Ícone de livro aberto,
                  color: Colors.teal, // Cor do ícone
                  size: 28.0, // Tamanho do ícone
                  // A cor do ícone será herdada do tema, ou pode ser definida explicitamente
                  // color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8.0), // Espaçamento entre ícone e texto
                Text(
                  'Meu Livro de Receitas',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 8.0), // Espaçamento entre o título e o subtítulo

            // Subtítulo
            Text(
              'Suas receitas salvas, ordenadas alfabeticamente. Clique para ver os detalhes ou adicione novas receitas.',
              style: Theme.of(context).textTheme.bodyMedium,
              // textAlign: TextAlign.start, // O Column com crossAxisAlignment.start já cuida disso
            ),
            const SizedBox(height: 20.0), // Espaçamento antes da próxima seção (lista de receitas)

            // TODO: Aqui virá a lista de receitas
            // Exemplo de placeholder se a lista estiver vazia:
            // Expanded(
            //   child: Center(
            //     child: Text(
            //       'Nenhuma receita cadastrada ainda.\nToque no botão "+" para adicionar sua primeira receita!',
            //       textAlign: TextAlign.center,
            //       style: Theme.of(context).textTheme.bodyLarge,
            //     ),
            //   ),
            // ),
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