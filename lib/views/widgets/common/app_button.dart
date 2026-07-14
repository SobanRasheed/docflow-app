import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FilledButton.icon(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: isDestructive ? theme.colorScheme.error : theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        disabledBackgroundColor: theme.colorScheme.surfaceContainerHighest,
      ),
      icon: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.onSurface,
              ),
            )
          : Icon(icon ?? Icons.arrow_forward),
      label: Text(label),
    );
  }
}