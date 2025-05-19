// lib/screens/import_recipe_screen.dart
import 'package:flutter/material.dart';

// Futuramente, você importará seu serviço de importação aqui
// import '../services/recipe_importer_service.dart';

class ImportRecipeScreen extends StatefulWidget {
  const ImportRecipeScreen({super.key});

  @override
  State<ImportRecipeScreen> createState() => _ImportRecipeScreenState();
}

class _ImportRecipeScreenState extends State<ImportRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _importRecipe() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _successMessage = null;
      });

      final url = _urlController.text.trim();

      // --- LÓGICA DE IMPORTAÇÃO (PLACEHOLDER) ---
      try {
        print('Tentando importar da URL: $url');
        // Exemplo: final recipe = await RecipeImporterService().importFromUrl(url);
        await Future.delayed(
            const Duration(seconds: 3)); // Simula chamada de rede

        if (url.contains("exemplo.com/receita-valida")) {
          setState(() {
            _successMessage = 'Receita "${url.substring(
                url.lastIndexOf('/') + 1)}" importada com sucesso! (Simulado)';
            _urlController.clear();
          });
        } else if (url.contains("falha")) {
          throw Exception(
              'Não foi possível encontrar uma receita válida nesta URL. (Simulado)');
        } else {
          throw Exception(
              'Formato de URL não suportado ou receita não encontrada. (Simulado)');
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Erro ao importar: ${e.toString()}';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
      // --- FIM DA LÓGICA DE IMPORTAÇÃO (PLACEHOLDER) ---
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Importar Receita da Web'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Cole a URL da página da receita que você deseja importar. Tentaremos extrair as informações automaticamente.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'URL da Receita',
                  hintText: 'https://www.sitecomreceitas.com/minha-receita',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link),
                ),
                keyboardType: TextInputType.url,
                validator: (value) { // CORREÇÃO APLICADA AQUI
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira uma URL.';
                  }
                  final uri = Uri.tryParse(value.trim());
                  // Garante que a URI não é nula, tem um esquema (http, https) e um caminho.
                  if (uri == null || !uri.isAbsolute || !uri.hasAbsolutePath) {
                    return 'Por favor, insira uma URL válida (ex: https://...).';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton.icon(
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Importar Receita'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    textStyle: const TextStyle(fontSize: 16.0),
                  ),
                  onPressed: _isLoading ? null : _importRecipe,
                ),
              const SizedBox(height: 20.0),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (_successMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    _successMessage!,
                    style: TextStyle(
                        color: Colors.green[700], fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 20.0),
              const Divider(),
              const SizedBox(height: 10.0),
              Text(
                'Nota: A importação funciona melhor com sites de receitas conhecidos e bem estruturados. Nem todos os sites são compatíveis.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}