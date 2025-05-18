import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';

class RecipeListScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Bot - Minhas Receitas'), // MODIFICADO AQUI
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Bem-vindo(a) ao Recipe Bot, ${user?.displayName ??
                    user?.email ?? 'Usuário'}!'), // MODIFICADO AQUI
            const SizedBox(height: 20),
            const Text('Aqui você verá suas receitas.'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Adicionar nova receita (TODO)')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Bot',
      // MODIFICADO AQUI
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        // Exemplo, ajuste conforme necessário para Recipe Bot
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue, // Exemplo
          accentColor: Colors.cyan, // Exemplo
          brightness: Brightness.light,
        ).copyWith(
          primary: Colors.blue[700],
          // Exemplo
          secondary: Colors.cyan[600],
          // Exemplo
          tertiary: Colors.teal[400],
          // Exemplo
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          background: Colors.white,
          surface: Colors.grey[100],
          onBackground: Colors.black87,
          onSurface: Colors.black87,
          error: Colors.redAccent,
          onError: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 4.0,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        // Exemplo
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue, // Exemplo
          accentColor: Colors.cyanAccent, // Exemplo
          brightness: Brightness.dark,
        ).copyWith(
          primary: Colors.blue[300],
          // Exemplo
          secondary: Colors.cyanAccent[100],
          // Exemplo
          tertiary: Colors.tealAccent[100],
          // Exemplo
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          background: Colors.grey[850],
          surface: Colors.grey[800],
          onBackground: Colors.white70,
          onSurface: Colors.white70,
          error: Colors.red,
          onError: Colors.black,
        ),
        appBarTheme: AppBarTheme(
          elevation: 4.0,
          backgroundColor: Colors.grey[850],
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      // themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return RecipeListScreen();
        }
        return const LoginScreen();
      },
    );
  }
}