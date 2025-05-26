import 'package:flutter/material.dart';
import 'package:recipe_bot/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipe_bot/services/firebase_options.dart'; // Gerado pelo FlutterFire CLI
import 'package:recipe_bot/widgets/auth_wrapper.dart';
import 'package:recipe_bot/screens/login_screen.dart';

// Ajuste 'package:recipe_bot/screens/home_screen.dart'
// para o caminho correto da sua HomeScreen se for diferente.
// Se estiver usando Firebase, lembre-se de importar e inicializar:
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart'; // Gerado pelo FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool firebaseInitializationFailed = false;
  try {
    // Se usar Firebase:
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization failed: $e');
    firebaseInitializationFailed = true;
  }
  runApp(MyApp(firebaseInitializationFailed: firebaseInitializationFailed));
}


class MyApp extends StatelessWidget {
  final bool firebaseInitializationFailed;

  const MyApp({super.key, required this.firebaseInitializationFailed});

  @override
  Widget build(BuildContext context) {
    if (firebaseInitializationFailed) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              'Failed to initialize Firebase. Please try again later.',
              style: TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

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
      home: const AuthWrapper(),
      // routes: {
      //   '/': (context) => const LoginScreen(), // Exemplo
      //   HomeScreen.routeName: (context) => const HomeScreen(), // Exemplo
      //   ImportRecipeScreen.routeName: (context) => const ImportRecipeScreen(), // Exemplo
      // },
    );
  }
}