import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../controllers/progress_controller.dart';
import '../../../core/theme/colors.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/progress_indicator_widget.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-redirect on completion
    Future.delayed(Duration.zero, () {
      ref.listenManual(progressControllerProvider, (prev, next) {
        next.whenData((state) {
          if (state.isCompleted && mounted) {
            context.go('/done');
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(progressControllerProvider);
    
    return Scaffold(
      body: SafeArea(
        child: asyncState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (state) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacings.screenHorizontal),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                if (state.error != null)
                  Column(
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: AppColors.danger),
                      const SizedBox(height: 16),
                      Text(
                        'Conversion Failed',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.slate500),
                      ),
                      const SizedBox(height: 32),
                      AppButton(
                        label: 'Back to Home',
                        icon: Icons.home,
                        onPressed: () => context.go('/'),
                      ),
                    ],
                  )
                else
                  ProgressIndicatorWidget(
                    progress: state.progress,
                    label: state.tool?.title ?? 'Processing',
                  ),
                const Spacer(),
                if (state.error == null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: TextButton(
                      onPressed: () {
                        ref.read(progressControllerProvider.notifier).cancel();
                        context.go('/');
                      },
                      child: const Text(
                        'Cancel Conversion',
                        style: TextStyle(color: AppColors.slate500),
                      ),
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