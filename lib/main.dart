import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/firebase_options.dart'; // Seu arquivo firebase_options.dart
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

// Importe seus temas se os tiver em arquivos separados
// import 'theme/theme.dart';

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
      theme: ThemeData( // Defina seu tema claro aqui
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent, // Cor primária para o tema claro
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData( // Defina seu tema escuro aqui
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent, // Cor primária para o tema escuro
          brightness: Brightness.dark,
          // Você pode querer ajustar outras cores para o tema escuro:
          // primary: Colors.lightBlue[300],
          // onPrimary: Colors.black,
          // surface: Colors.grey[850],
          // onSurface: Colors.white,
          // background: Colors.grey[900],
          // onBackground: Colors.white,
          // error: Colors.redAccent[100],
          // onError: Colors.black,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      // Ou ThemeMode.light, ThemeMode.dark
      home: const AuthWrapper(), // Usar um Wrapper para verificar o estado de auth
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // StreamBuilder ouve as mudanças no estado de autenticação do Firebase
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Enquanto espera a conexão
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // Se o usuário estiver logado, vá para HomeScreen
        if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen();
        }
        // Caso contrário, vá para LoginScreen
        return LoginScreen();
      },
    );
  }
}