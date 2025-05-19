import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Para FirebaseAuthException
import 'package:logging/logging.dart';

import '../services/auth_service.dart';
import 'home_screen.dart'; // Para Logging

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Logger _log = Logger('RegisterScreen');
  final AuthService _authService = AuthService(); // <-- DESCOMENTE ESTA LINHA

  // final AuthService _authService = AuthService(); // Descomente quando tiver o serviço
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Método para navegar para HomeScreen ou LoginScreen após registro
  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => const HomeScreen()),);
  }

  Future<void> _registerWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      try {
        _log.fine('Attempting to register with email: $_email');
        await _authService.createUserWithEmailAndPassword(_email, _password);
        _log.info('Registration successful for email: $_email, navigating.');
        if (mounted) {
           _navigateToNextScreen();
         }
      } catch (e, s) {
        String message = "Falha ao registrar. Tente novamente.";
        if (e is FirebaseAuthException) {
          if (e.code == 'weak-password') {
            message = 'A senha fornecida é muito fraca.';
          } else if (e.code == 'email-already-in-use') {
            message = 'Este e-mail já está em uso por outra conta.';
          } else if (e.code == 'invalid-email') {
            message = 'O formato do e-mail é inválido.';
          }
        }
        setState(() {
          _errorMessage = message;
          _log.severe("Registration Error: $message", e, s);
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // UI Similar à LoginScreen, mas com campos para registro
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Nova Conta'),
        leading: IconButton( // Botão para voltar para a tela de login
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Ícone e Título (similar ao Login)
                Icon(
                  Icons.person_add_alt_1,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Criar Conta',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),

                // Campo Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'seuemail@exemplo.com',
                    prefixIcon: Icon(
                        Icons.email_outlined, color: theme.colorScheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
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
                  onSaved: (value) => _email = value!,
                ),
                const SizedBox(height: 16),

                // Campo Senha
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    hintText: 'Crie uma senha',
                    prefixIcon: Icon(
                        Icons.lock_outline, color: theme.colorScheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    // Adicionar suffixIcon para visibilidade da senha se desejar
                  ),
                  obscureText: true,
                  // Adicionar lógica para _isPasswordVisible se necessário
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma senha';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value!,
                ),
                const SizedBox(height: 16),

                // Opcional: Campo Confirmar Senha
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    hintText: 'Repita sua senha',
                    prefixIcon: Icon(
                        Icons.lock_outline, color: theme.colorScheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, confirme sua senha';
                    }
                    if (value != _passwordController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

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

                _isLoading
                    ? Center(child: CircularProgressIndicator(
                    color: theme.colorScheme.tertiary))
                    : ElevatedButton.icon(
                  icon: const Icon(Icons.app_registration),
                  label: const Text('Registrar'),
                  onPressed: _registerWithEmailAndPassword,
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
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _isLoading ? null : () =>
                      Navigator.of(context).pop(), // Volta para Login
                  child: Text(
                    'Já tem uma conta? Entrar',
                    style: TextStyle(color: theme.colorScheme.tertiary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}