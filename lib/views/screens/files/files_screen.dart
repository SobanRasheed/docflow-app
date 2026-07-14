import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../controllers/files_controller.dart';
import '../../../core/theme/colors.dart';
import '../../../core/utils/formatters.dart';
import '../../widgets/common/empty_state.dart';

class FilesScreen extends ConsumerWidget {
  const FilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filesAsync = ref.watch(filesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Files'),
        actions: [
          filesAsync.maybeWhen(
            data: (files) => files.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.delete_sweep),
                    onPressed: () => _showClearDialog(context, ref),
                  ),
            orElse: () => const SizedBox.shrink(),
          )
        ],
      ),
      body: filesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (files) {
          if (files.isEmpty) {
            return const EmptyState(
              icon: Icons.folder_off_outlined,
              title: 'No History Yet',
              subtitle: 'Your converted files will appear here.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacings.screenHorizontal,
              vertical: 16,
            ),
            itemCount: files.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final file = files[index];
              final exists = File(file.outputPath).existsSync();
              return Dismissible(
                key: ValueKey(file.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    borderRadius: BorderRadius.circular(AppSpacings.cardRadius),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  ref.read(filesControllerProvider.notifier).deleteRecord(file.id);
                },
                child: Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.slate100,
                        borderRadius: BorderRadius.circular(AppSpacings.iconRadius),
                      ),
                      child: const Icon(Icons.insert_drive_file, color: AppColors.slate600),
                    ),
                    title: Text(
                      file.inputName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '${file.toolTitle} • ${Formatters.formatDate(file.createdAt)}',
                      style: const TextStyle(fontSize: 12, color: AppColors.slate500),
                    ),
                    trailing: exists
                        ? IconButton(
                            icon: const Icon(Icons.share_outlined),
                            onPressed: () => SharePlus.instance.share(ShareParams(files: [XFile(file.outputPath)])),
                          )
                        : const Tooltip(
                            message: 'File missing',
                            child: Icon(Icons.warning_amber, color: AppColors.warning),
                          ),
                    onTap: exists ? null : () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('File no longer exists.')),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showClearDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear History?'),
        content: const Text('This will remove all conversion records. Saved files will remain on your device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            onPressed: () {
              ref.read(filesControllerProvider.notifier).clearHistory();
              Navigator.pop(ctx);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}