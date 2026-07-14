import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../controllers/upload_controller.dart';
import '../../../core/theme/colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/tool_type.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/empty_state.dart';

class UploadScreen extends ConsumerWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tool = ToolType.byId(GoRouterState.of(context).pathParameters['toolId']!)!;
    final uploadState = ref.watch(uploadControllerProvider);

    // Initialize tool on first build
    Future.microtask(() {
      if (ref.read(uploadControllerProvider).value?.tool?.id != tool.id) {
        ref.read(uploadControllerProvider.notifier).setTool(tool);
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(tool.title)),
      body: uploadState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (state) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacings.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                'Select your file${tool.supportsMultiple ? "s" : ""}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Accepted formats: ${tool.acceptedInputs.join(", ")}',
                style: const TextStyle(color: AppColors.slate500),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: state.files.isEmpty
                    ? EmptyState(
                        icon: Icons.upload_file,
                        title: 'No files selected',
                        subtitle: 'Tap below to choose files from your device.',
                      )
                    : ListView.separated(
                        itemCount: state.files.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final file = state.files[index];
                          return ListTile(
                            leading: const Icon(Icons.insert_drive_file, color: AppColors.brand600),
                            title: Text(file.path.split('/').last),
                            subtitle: Text(Formatters.formatBytes(file.lengthSync())),
                            trailing: IconButton(
                              icon: const Icon(Icons.close, color: AppColors.slate400),
                              onPressed: () => ref.read(uploadControllerProvider.notifier).clearFiles(),
                            ),
                            tileColor: AppColors.slate50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSpacings.cardRadius),
                            ),
                          );
                        },
                      ),
              ),
              if (state.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    state.error!,
                    style: const TextStyle(color: AppColors.danger),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 16),
              AppButton(
                label: state.files.isEmpty ? 'Choose File' : 'Convert Now',
                icon: state.files.isEmpty ? Icons.folder_open : Icons.flash_on,
                onPressed: state.files.isEmpty
                    ? () => ref.read(uploadControllerProvider.notifier).pickFiles()
                    : () => context.go('/progress'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}