import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../controllers/done_controller.dart';
import '../../../core/theme/colors.dart';
import '../../../core/utils/formatters.dart';
import '../../widgets/common/app_button.dart';

class DoneScreen extends ConsumerWidget {
  const DoneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doneState = ref.watch(doneControllerProvider);

    if (doneState.result == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final result = doneState.result!;
    final tool = doneState.tool!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacings.screenHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.brand100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, size: 80, color: AppColors.brand600),
              ),
              const SizedBox(height: 32),
              Text(
                'File Converted!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.slate900,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your ${tool.title} is ready.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.slate500),
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.description, color: AppColors.brand600),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result.path.split('/').last,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              Formatters.formatBytes(result.lengthSync()),
                              style: const TextStyle(color: AppColors.slate500, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              AppButton(
                label: 'Share File',
                icon: Icons.share,
                onPressed: () => Share.shareXFiles([XFile(result.path)]),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacings.cardRadius),
                  ),
                ),
                onPressed: () {
                  ref.read(doneControllerProvider.notifier).reset();
                  context.go('/');
                },
                child: const Text('Convert Another File'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}