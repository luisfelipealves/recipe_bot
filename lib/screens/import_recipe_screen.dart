// lib/screens/import_recipe_screen.dart
import 'package:flutter/material.dart';

class ImportRecipeScreen extends StatelessWidget {
  const ImportRecipeScreen({super.key});

  static const routeName = '/import-recipe'; // Para navegação nomeada (opcional)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Importar Receita'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tela de Importação de Receita',
              style: TextStyle(fontSize: 20), // Exemplo de estilo
            ),
            SizedBox(height: 20),
            Text(
              'Aqui você poderá importar suas receitas.',
              textAlign: TextAlign.center,
            ),
            // TODO: Implementar os campos e a lógica para importar receitas
          ],
        ),
      ),
    );
  }
}