// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    // Ou, se estiver usando rotas nomeadas:
    // Navigator.of(context).pushNamed(ImportRecipeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final ThemeData theme = Theme.of(context);
    final Color? iconColor = theme.appBarTheme.actionsIconTheme
        ?.color ??
        theme.appBarTheme.iconTheme?.color ??
        theme.primaryIconTheme.color;

    final Color? textColor = theme.textTheme.labelLarge?.color?.withOpacity(1.0) ?? iconColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Bot'),
        actions: [
          TextButton.icon(
            icon: Icon(
              Icons.add_circle_outline,
              color: iconColor,
            ),
            label: Text(
              'Importar Receita',
              style: TextStyle(
                  color: textColor), // Usa a cor do tema para o texto
            ),
            onPressed: () => _navigateToImportRecipeScreen(context),
            // Removido TextButton.styleFrom para herdar o estilo do tema,
            // ou você pode definir um style aqui que use cores do tema.
            // Exemplo para garantir que o foregroundColor também use o tema:
            style: TextButton.styleFrom(
              foregroundColor: textColor, // Cor do texto e ícone quando pressionado/hover
            ),
          ),
          // Botão de Logout
          IconButton(
            icon: Icon(Icons.logout, color: iconColor),
            // Aplica a mesma lógica de cor
            tooltip: 'Sair',
            onPressed: () => _signOut(context),
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
            const SizedBox(height: 20),
            const Text(
              'Aqui serão listadas suas receitas cadastradas.',
              textAlign: TextAlign.center,
            ),
            // TODO: Implementar a lista de receitas
          ],
        ),
      ),
    );
  }
}