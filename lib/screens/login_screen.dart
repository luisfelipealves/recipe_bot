import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Para FirebaseAuthException
import 'package:logging/logging.dart';

import '../services/auth_service.dart';
import 'home_screen.dart'; // Sua tela principal
import 'register_screen.dart'; // Sua tela de registro
// import 'password_reset_screen.dart'; // Se tiver uma tela separada para reset de senha

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Logger _log = Logger('LoginScreen');
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;
  bool _isPasswordVisible = false; // Para alternar a visibilidade da senha

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToHomeScreen() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void _navigateToRegisterScreen() {
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
      );
    }
  }

  void _handleForgotPassword() async {
    // Opção 1: Mostrar um diálogo para inserir o e-mail
    String? emailForReset = _emailController.text.trim();
    if (emailForReset.isEmpty) {
      final result = await showDialog<String>(
        context: context,
        builder: (context) {
          TextEditingController tempEmailController = TextEditingController();
          return AlertDialog(
            title: const Text('Redefinir Senha'),
            content: TextField(
              controller: tempEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: "Digite seu e-mail"),
            ),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Enviar'),
                onPressed: () =>
                    Navigator.of(context).pop(tempEmailController.text),
              ),
            ],
          );
        },
      );
      emailForReset = result;
    }

    if (emailForReset != null && emailForReset.isNotEmpty) {
      setState(() => _isLoading = true);
      try {
        await _authService.sendPasswordResetEmail(emailForReset);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(
                'E-mail de redefinição enviado para $emailForReset.')),
          );
        }
      } on FirebaseAuthException catch (e) {
        _log.warning('Password Reset Error: ${e.code} - ${e.message}');
        String message = "Falha ao enviar e-mail de redefinição.";
        if (e.code == 'user-not-found') {
          message = "Nenhum usuário encontrado com este e-mail.";
        } else if (e.code == 'invalid-email') {
          message = "O formato do e-mail é inválido.";
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red),
          );
        }
      } catch (e) {
        _log.severe('Password Reset Error: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ocorreu um erro: ${e.toString()}'),
                backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else
    if (emailForReset != null) { // Checa se não foi cancelado, mas estava vazio
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(
            'Por favor, insira um e-mail para redefinir a senha.')),
      );
    }
    // Opção 2: Navegar para uma tela dedicada
    // if (mounted) {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) => const PasswordResetScreen()),
    //   );
    // }
  }


  Future<void> _loginWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        _log.fine('Attempting to login with email: $_email');
        UserCredential? userCredential = await _authService
            .signInWithEmailAndPassword(_email, _password);

        if (userCredential?.user != null) {
          User user = userCredential!.user!;
          // Recarregar o usuário para garantir que o status de emailVerified esteja atualizado
          await user.reload();
          user = _authService
              .currentUser!; // Pega a instância mais recente após o reload

          if (!user.emailVerified) {
            _log.warning('User ${_email} logged in but email not verified.');
            if (mounted) {
              setState(() {
                _errorMessage =
                'Seu e-mail ainda não foi verificado. Por favor, verifique sua caixa de entrada.';
                _isLoading = false;
              });
              // Oferecer opção para reenviar e-mail
              _showResendVerificationEmailDialog(user);
            }
            return; // Impede a navegação para HomeScreen
          }

          // E-mail verificado
          _log.info(
              'Login successful for verified email: $_email, navigating to HomeScreen.');
          _navigateToHomeScreen();
        } else {
          // Não deveria acontecer se signInWithEmailAndPassword não lançou exceção e retornou null
          _log.warning(
              'Login attempt for $_email resulted in null UserCredential without FirebaseException.');
          if (mounted) {
            setState(() {
              _errorMessage =
              'Falha no login. Usuário não encontrado ou credenciais inválidas.';
              _isLoading = false;
            });
          }
        }
      } on FirebaseAuthException catch (e) {
        _log.warning(
            "FirebaseAuthException during login for $_email: ${e.code} - ${e
                .message}");
        String message;
        switch (e.code) {
          case 'user-not-found':
            message = 'Nenhum usuário encontrado com este e-mail.';
            break;
          case 'wrong-password':
            message = 'Senha incorreta.';
            break;
          case 'invalid-email':
            message = 'O formato do e-mail é inválido.';
            break;
          case 'user-disabled':
            message = 'Este usuário foi desabilitado.';
            break;
          case 'too-many-requests':
            message = 'Muitas tentativas de login. Tente novamente mais tarde.';
            break;
          default:
            message = 'Ocorreu um erro de autenticação.';
        }
        if (mounted) {
          setState(() {
            _errorMessage = message;
            _isLoading = false;
          });
        }
      } catch (e, s) {
        _log.severe('Generic error during login for $_email: $e', e, s);
        if (mounted) {
          setState(() {
            _errorMessage = 'Ocorreu um erro inesperado. Tente novamente.';
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      _log.fine('Attempting Google Sign-In...');
      UserCredential? userCredential = await _authService.signInWithGoogle();
      if (userCredential?.user != null) {
        _log.info('Google Sign-In successful for user: ${userCredential!.user!
            .displayName}, navigating to HomeScreen.');
        // Para o Google, o e-mail geralmente já vem verificado.
        // Você pode adicionar uma checagem aqui se quiser ser extra cauteloso ou se seu fluxo exigir.
        _navigateToHomeScreen();
      } else {
        // Usuário cancelou o fluxo do Google ou houve um erro não capturado como exceção.
        _log.info(
            'Google Sign-In cancelled by user or resulted in null UserCredential.');
        if (mounted) {
          // Não definir _errorMessage aqui, pois o cancelamento pelo usuário não é um erro.
          // Apenas garantir que _isLoading seja false.
          setState(() {
            _isLoading = false;
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      _log.warning("FirebaseAuthException during Google Sign-In: ${e.code} - ${e
          .message}");
      String message = 'Falha ao fazer login com Google.';
      // Você pode adicionar tratamento para códigos de erro específicos do Google/Firebase aqui
      // e.g. e.code == 'account-exists-with-different-credential'
      if (mounted) {
        setState(() {
          _errorMessage = message;
          _isLoading = false;
        });
      }
    } catch (e, s) {
      _log.severe('Generic error during Google Sign-In: $e', e, s);
      if (mounted) {
        setState(() {
          _errorMessage =
          e.toString().contains("Falha ao fazer login com Google")
              ? e.toString() // Se a exceção já é a mensagem que queremos
              : 'Ocorreu um erro inesperado durante o login com Google.';
          _isLoading = false;
        });
      }
    }
  }

  void _showResendVerificationEmailDialog(User user) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('E-mail Não Verificado'),
            content: Text(
                'Seu e-mail (${user
                    .email}) ainda não foi verificado. Por favor, verifique sua caixa de entrada. Você gostaria de reenviar o e-mail de verificação?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Reenviar E-mail'),
                onPressed: () async {
                  Navigator.of(context).pop(); // Fecha o diálogo
                  setState(() => _isLoading = true);
                  try {
                    await _authService
                        .sendVerificationEmail(); // Usa o método do AuthService
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(
                            'E-mail de verificação reenviado para ${user
                                .email}.')),
                      );
                    }
                  } catch (e) {
                    _log.severe('Error resending verification email: $e');
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text(
                            'Falha ao reenviar e-mail de verificação.'),
                            backgroundColor: Colors.red),
                      );
                    }
                  } finally {
                    if (mounted) {
                      setState(() => _isLoading = false);
                    }
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Para usar o tema do app

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Logo ou Ícone
                  Icon(
                    Icons.lock_open, // Exemplo de ícone
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bem-vindo de Volta!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Faça login para continuar',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Campo Email
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'seuemail@exemplo.com',
                      prefixIcon: Icon(Icons.email_outlined,
                          color: theme.colorScheme.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: theme.colorScheme
                            .outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: theme.colorScheme.primary,
                            width: 2),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(
                          value)) {
                        return 'Por favor, insira um email válido';
                      }
                      return null;
                    },
                    onSaved: (value) => _email = value!.trim(),
                  ),
                  const SizedBox(height: 16),

                  // Campo Senha
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      hintText: 'Sua senha',
                      prefixIcon: Icon(
                          Icons.lock_outline, color: theme.colorScheme.primary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: theme.colorScheme.primary,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: theme.colorScheme
                            .outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: theme.colorScheme.primary,
                            width: 2),
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira sua senha';
                      }
                      // Você pode adicionar mais validações de senha aqui se desejar (ex: comprimento mínimo)
                      return null;
                    },
                    onSaved: (value) => _password = value!,
                  ),
                  const SizedBox(height: 8),

                  // Link "Esqueceu a senha?"
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _isLoading ? null : _handleForgotPassword,
                      child: Text(
                        'Esqueceu a senha?',
                        style: TextStyle(color: theme.colorScheme.tertiary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Exibir mensagem de erro
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                            color: theme.colorScheme.error, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // Botão de Login com Email/Senha
                  _isLoading
                      ? Center(child: CircularProgressIndicator(
                      color: theme.colorScheme.tertiary))
                      : ElevatedButton.icon(
                    icon: const Icon(Icons.login),
                    label: const Text('Entrar'),
                    onPressed: _loginWithEmailAndPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Divisor "OU"
                  Row(
                    children: <Widget>[
                      Expanded(child: Divider(color: theme.dividerColor
                          .withOpacity(0.5))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'OU',
                          style: TextStyle(color: theme.colorScheme
                              .onSurfaceVariant),
                        ),
                      ),
                      Expanded(child: Divider(color: theme.dividerColor
                          .withOpacity(0.5))),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Botão de Login com Google
                  ElevatedButton.icon(
                    icon: Image.asset(
                        'assets/images/android_light_rd_na@1x.png', height: 24.0),
                    // Substitua pelo caminho do seu logo do Google
                    label: const Text('Entrar com Google'),
                    onPressed: _isLoading ? null : _loginWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      // Cor de fundo típica para botão do Google
                      foregroundColor: Colors.black87,
                      // Cor do texto
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: theme.colorScheme
                            .outline), // Borda sutil
                      ),
                      elevation: 2,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Link para Tela de Registro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Não tem uma conta? ',
                        style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : _navigateToRegisterScreen,
                        child: Text(
                          'Cadastre-se',
                          style: TextStyle(
                            color: theme.colorScheme.tertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}