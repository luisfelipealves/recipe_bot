// lib/screens/import_recipe_screen.dart
import 'package:flutter/material.dart';
import 'package:recipe_bot/services/recipe_extraction_service.dart';
import 'package:recipe_bot/models/recipe_model.dart';
import 'package:recipe_bot/screens/view_extracted_recipe_screen.dart';

class ImportRecipeScreen extends StatefulWidget {
  const ImportRecipeScreen({super.key});

  static const routeName = '/import-recipe';

  @override
  State<ImportRecipeScreen> createState() => _ImportRecipeScreenState();
}

class _ImportRecipeScreenState extends State<ImportRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  bool _isLoading = false;

  Future<void> _importRecipe() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = _urlController.text;

    try {
      final Recipe recipe = await extractRecipeFromUrl(url);

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewExtractedRecipeScreen(recipe: recipe),
          ),
        );
      }

    } catch (e) {
      // 3. Ensure _isLoading is set to false in all error paths within the catch block.
      setState(() {
        _isLoading = false;
      });

      String errorMessage;
      // 2. Modify this to be more user-friendly for the specific known error
      if (e is Exception && e.toString().contains('Invalid recipe URL: Must contain the word "recipe".')) {
        errorMessage = "Could not find a recipe at the provided URL. Please ensure it's a valid recipe link.";
      } else {
        errorMessage = "An unexpected error occurred. Please try again.";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Importar Receita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Recipe URL',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., https://www.example.com/recipe',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a URL';
                  }
                  if (!RegExp(r'^https?:\/\/').hasMatch(value)) {
                    return 'Please enter a valid URL (e.g., http://example.com)';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _importRecipe,
                  child: const Text('Import Recipe'),
                ),
              const SizedBox(height: 20),
              const Text(
                'Aqui você poderá importar suas receitas de URLs.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}