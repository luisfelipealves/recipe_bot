// lib/screens/view_extracted_recipe_screen.dart
import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe_model.dart';
// Ingredient and Instruction models are implicitly available through recipe_model.dart

class ViewExtractedRecipeScreen extends StatelessWidget {
  final Recipe recipe;

  const ViewExtractedRecipeScreen({super.key, required this.recipe});

  static const routeName = '/view-extracted-recipe'; // Optional: for named navigation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extracted Recipe'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Recipe Title
            Text(
              recipe.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),

            // Recipe Image (if available)
            if (recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Image.network(
                    recipe.imageUrl!,
                    height: 200, // Specify a height
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return const Center(child: Text('Could not load image.', style: TextStyle(color: Colors.red)));
                    },
                  ),
                ),
              )
            else
              Container( // Placeholder if no image
                height: 200,
                color: Colors.grey[300],
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Icon(Icons.image_not_supported, color: Colors.grey[600], size: 50),
                ),
              ),

            // Recipe Description
            if (recipe.description != null && recipe.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  recipe.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            
            // Cooking Time
            if (recipe.cookingTimeMinutes != null)
              Text(
                'Cooking Time: ${recipe.cookingTimeMinutes} minutes',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontStyle: FontStyle.italic),
              ),
            const SizedBox(height: 16.0),

            // Ingredients Section
            Text(
              'Ingredients',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            if (recipe.ingredients.isNotEmpty)
              ListView.builder(
                shrinkWrap: true, // Important for ListView inside Column
                physics: const NeverScrollableScrollPhysics(), // Disable scrolling for this ListView
                itemCount: recipe.ingredients.length,
                itemBuilder: (context, index) {
                  final ingredient = recipe.ingredients[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text('${ingredient.quantity} ${ingredient.name}'),
                    subtitle: ingredient.notes != null && ingredient.notes!.isNotEmpty ? Text(ingredient.notes!) : null,
                  );
                },
              )
            else
              const Text('No ingredients listed.'),
            const SizedBox(height: 16.0),

            // Instructions Section
            Text(
              'Instructions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            if (recipe.instructions.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recipe.instructions.length,
                itemBuilder: (context, index) {
                  final instruction = recipe.instructions[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${instruction.stepNumber}')),
                    title: Text(instruction.description),
                  );
                },
              )
            else
              const Text('No instructions provided.'),
            const SizedBox(height: 24.0), // Space before buttons
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.bookmark_add_outlined),
              label: const Text('Add to Cookbook'),
              onPressed: () {
                // 1. For the "Add to Cookbook" button:
                //    - Print a message to the console
                print('Recipe "${recipe.title}" added to cookbook (simulated).');
                //    - Show a SnackBar confirming the action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Recipe "${recipe.title}" added to cookbook!')),
                );
                //    - After showing the SnackBar, navigate back
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, foregroundColor: Colors.white),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.cancel_outlined),
              label: const Text('Discard'),
              onPressed: () {
                // 2. For the "Discard" button:
                //    - Add a SnackBar before navigating back
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Recipe discarded.')),
                );
                //    - Ensure Navigator.pop(context) is called after the SnackBar
                Navigator.pop(context);
                // Removed: print('Discard pressed for: ${recipe.title}');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
