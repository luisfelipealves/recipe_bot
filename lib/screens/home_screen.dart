import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart'; // Supondo que seu AuthService tenha o método signOut
import 'login_screen.dart'; // Para redirecionar ao fazer logout

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await AuthService().signOut(); // Use sua instância de AuthService
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false, // Remove todas as rotas anteriores
      );
    } catch (e) {
      print("Erro ao fazer logout: $e");
      // Opcional: Mostrar uma mensagem de erro para o usuário
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer logout: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Receitas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
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
              'Bem-vindo(a)!',
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineSmall,
            ),
            if (user != null && user.displayName != null &&
                user.displayName!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  user.displayName!,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge,
                ),
              ),
            if (user != null && user.email != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  user.email!,
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium,
                ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navegar para a tela de adicionar nova receita
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('TODO: Adicionar nova receita')),
          );
        },
        tooltip: 'Adicionar Receita',
        child: const Icon(Icons.add),
      ),
    );
  }
}