import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData iconData;
  final VoidCallback? onActionButtonPressed; // Callback para um botão de ação opcional
  final String? actionButtonText; // Texto para o botão de ação opcional

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.iconData = Icons.inbox_rounded, // Um ícone padrão
    this.onActionButtonPressed,
    this.actionButtonText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              size: 80.0,
              color: theme.colorScheme.secondary.withOpacity(
                  0.7), // Cor sutil do tema
            ),
            const SizedBox(height: 24.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            // Condição para o botão de ação
            if (onActionButtonPressed != null && actionButtonText != null)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_circle_outline),
                  // Ícone fixo para o botão de ação
                  label: Text(actionButtonText!),
                  // Uso do '!' (null assertion operator)
                  onPressed: onActionButtonPressed,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    textStyle: theme.textTheme.labelLarge,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}