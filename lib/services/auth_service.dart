import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:logging/logging.dart'; // Para checagem web

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream para o estado de autenticação do usuário
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Obter usuário atual
  User? get currentUser => _firebaseAuth.currentUser;

  // Login com Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Iniciar o processo de Google Sign In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // O usuário cancelou o login
        return null;
      }

      // Obter detalhes de autenticação da requisição
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Criar uma nova credencial para o Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Fazer login no Firebase com a credencial
      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      // Você pode querer tratar erros específicos aqui ou lançá-los
      print("FirebaseAuthException (Google Sign-In): ${e.message}");
      throw e; // Re-lança para ser tratado na UI
    } catch (e) {
      print("Error signing in with Google: $e");
      throw e; // Re-lança para ser tratado na UI
    }
  }

  // Login com Email e Senha
  Future<UserCredential?> signInWithEmailAndPassword(String email,
      String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException (Email/Password Sign-In): ${e.message}");
      throw e; // Re-lança para ser tratado na UI
    } catch (e) {
      print("Error signing in with email and password: $e");
      throw e; // Re-lança para ser tratado na UI
    }
  }

  // Registro com Email e Senha (Exemplo)
  Future<UserCredential?> createUserWithEmailAndPassword(String email,
      String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException (Email/Password Sign-Up): ${e.message}");
      throw e;
    } catch (e) {
      print("Error creating user with email and password: $e");
      throw e;
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      if (!kIsWeb) { // Google Sign-Out não é necessário ou diferente na Web
        await _googleSignIn.signOut();
      }
      await _firebaseAuth.signOut();
    } catch (e) {
      print("Error signing out: $e");
      // Trate o erro como apropriado
    }
  }
}