import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color,
  });

  final String label;
  final Widget icon;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color ?? AppColors.slate700,
        backgroundColor: Colors.white,
        side: const BorderSide(color: AppColors.slate200),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}
