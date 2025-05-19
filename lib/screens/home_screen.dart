// lib/screens/home_screen.dart
import 'package:flutter/material.dart';

// Se você não usa mais FirebaseAuth diretamente nesta tela APÓS remover os dados do usuário,
// pode até remover o import abaixo, mas AuthService ainda pode depender dele.
// import 'package:firebase_auth/firebase_auth.dart';

// Ajuste os caminhos de importação conforme a estrutura do seu projeto
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'import_recipe_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await AuthService().signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Erro ao fazer logout: $e");
      ScaffoldMessenger.of(context).showSnackBar(
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
    // Não precisamos mais de `final User? user = FirebaseAuth.instance.currentUser;`
    // se não estamos exibindo os dados do usuário diretamente aqui.

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Meu Livro de Receitas',
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineSmall,
            ),
            // Seções de displayName e email do usuário foram removidas daqui.
            const SizedBox(height: 20),
            const Text(
              'Aqui serão listadas suas receitas cadastradas.',
              textAlign: TextAlign.center,
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