import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Presumindo que você usa para o Google Sign-In
import 'package:logging/logging.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // Se você estiver usando Google Sign-In
  final Logger _log = Logger('AuthService');

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  /// Método que você já possui para verificar se o usuário está logado
  Future<User?> checkUserLoggedIn() async {
    // Sua implementação existente aqui. Geralmente, apenas retorna _firebaseAuth.currentUser
    // ou pode ter lógica adicional se você verificar tokens customizados, etc.
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      _log.fine('User already logged in: ${user.uid}');
      // Pode ser útil recarregar para garantir que os dados do usuário (como emailVerified) estejam atualizados
      // await user.reload();
      // return _firebaseAuth.currentUser; // Retorna o usuário possivelmente atualizado
    } else {
      _log.fine('No user currently logged in.');
    }
    return user;
  }

  /// Cria um novo usuário com e-mail e senha e envia um e-mail de verificação.
  Future<UserCredential?> createUserWithEmailAndPassword(String email,
      String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _log.info('User successfully created: ${userCredential.user
          ?.uid} for email: ${userCredential.user?.email}');

      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        try {
          await userCredential.user!.sendEmailVerification();
          _log.info(
              'Verification email sent to ${userCredential.user!.email}.');
        } catch (e, s) {
          _log.warning(
              'Failed to send verification email to ${userCredential.user!
                  .email}. Error: $e', e, s);
        }
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _log.warning(
          'FirebaseAuthException during user creation for email $email: ${e
              .code} - ${e.message}');
      rethrow;
    } catch (e, s) {
      _log.severe(
          'An unexpected error occurred during user creation for email $email.',
          e, s);
      throw Exception('Falha ao criar usuário. Tente novamente mais tarde.');
    }
  }

  /// Realiza o login de um usuário com e-mail e senha.
  Future<UserCredential?> signInWithEmailAndPassword(String email,
      String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _log.info('User successfully signed in: ${userCredential.user
          ?.uid} for email: ${userCredential.user?.email}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _log.warning('FirebaseAuthException during sign in for email $email: ${e
          .code} - ${e.message}');
      rethrow;
    } catch (e, s) {
      _log.severe(
          'An unexpected error occurred during sign in for email $email.', e,
          s);
      throw Exception('Falha ao fazer login. Tente novamente mais tarde.');
    }
  }

  /// Método que você já possui para login com Google
  Future<UserCredential?> signInWithGoogle() async {
    _log.fine('Attempting Google Sign-In...');
    try {
      // Sua implementação existente para Google Sign-In aqui
      // Exemplo comum:
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _log.info('Google Sign-In aborted by user.');
        return null; // Usuário cancelou o fluxo de login do Google
      }

      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(
          credential);
      _log.info(
          'Successfully signed in with Google: ${userCredential.user?.uid}');
      // Após o login com Google, o e-mail geralmente já é considerado verificado
      // se vier de um provedor confiável como o Google.
      // Não é necessário enviar um e-mail de verificação aqui.
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _log.warning('FirebaseAuthException during Google Sign-In: ${e.code} - ${e
          .message}');
      rethrow;
    } catch (e, s) {
      _log.severe('An unexpected error occurred during Google Sign-In.', e, s);
      if (e.toString().contains('PlatformException(sign_in_failed')) {
        throw Exception(
            'Falha ao fazer login com Google. Verifique sua conexão ou tente novamente.');
      }
      throw Exception('Ocorreu um erro durante o login com Google.');
    }
  }

  /// Realiza o logout do usuário atual.
  Future<void> signOut() async {
    try {
      // Se o usuário fez login com Google, também é bom fazer signOut do Google.
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
        _log.info('Google user signed out.');
      }
      await _firebaseAuth.signOut();
      _log.info('Firebase user signed out successfully.');
    } catch (e, s) {
      _log.severe('Error signing out.', e, s);
      throw Exception('Falha ao fazer logout. Tente novamente.');
    }
  }

  /// Envia (ou reenvia) um e-mail de verificação para o usuário atualmente logado.
  Future<bool> sendVerificationEmail() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        _log.info('Email ${user.email} is already verified.');
        return true;
      }
      try {
        await user.sendEmailVerification();
        _log.info('Verification email sent to ${user.email}.');
        return true;
      } catch (e, s) {
        _log.severe(
            'Failed to send verification email to ${user.email}.', e, s);
        return false;
      }
    } else {
      _log.warning(
          'No user is currently signed in to send a verification email.');
      return false;
    }
  }

  /// Verifica se o e-mail do usuário atual foi verificado.
  Future<bool> isEmailVerified() async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      _log.info('No user signed in, cannot check email verification status.');
      return false;
    }
    try {
      await user.reload();
      User? refreshedUser = _firebaseAuth
          .currentUser; // Pega a instância mais recente
      if (refreshedUser != null) {
        _log.fine('Current email verification status for ${refreshedUser
            .email}: ${refreshedUser.emailVerified}');
        return refreshedUser.emailVerified;
      }
      return false;
    } catch (e, s) {
      _log.severe(
          'Error reloading user data to check email verification.', e, s);
      return false;
    }
  }

  /// Envia um e-mail para redefinição de senha.
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      _log.info('Password reset email sent to $email.');
    } on FirebaseAuthException catch (e) {
      _log.warning(
          'FirebaseAuthException during password reset for email $email: ${e
              .code} - ${e.message}');
      rethrow;
    } catch (e, s) {
      _log.severe(
          'An unexpected error occurred sending password reset email to $email.',
          e, s);
      throw Exception('Falha ao enviar e-mail de redefinição de senha.');
    }
  }
}