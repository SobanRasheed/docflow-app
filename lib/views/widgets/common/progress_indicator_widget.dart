import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/colors.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({
    super.key,
    required this.progress,
    required this.label,
  });

  final double progress;
  final String label;

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).toInt();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 160,
              width: 160,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 12,
                backgroundColor: AppColors.slate200,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brand600),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.slate900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(color: AppColors.slate500),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}