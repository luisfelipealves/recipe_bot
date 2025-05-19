import 'package:flutter/material.dart';
import 'package:recipe_bot/screens/home_screen.dart';

// Ajuste 'package:recipe_bot/screens/home_screen.dart'
// para o caminho correto da sua HomeScreen se for diferente.
// Se estiver usando Firebase, lembre-se de importar e inicializar:
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart'; // Gerado pelo FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Se usar Firebase:
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Bot',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[850],
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.tealAccent,
          foregroundColor: Colors.black,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
      // routes: {
      //   '/': (context) => const LoginScreen(), // Exemplo
      //   HomeScreen.routeName: (context) => const HomeScreen(), // Exemplo
      //   ImportRecipeScreen.routeName: (context) => const ImportRecipeScreen(), // Exemplo
      // },
    );
  }
}