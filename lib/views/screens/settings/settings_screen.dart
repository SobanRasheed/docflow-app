import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/settings_controller.dart';
import '../../../core/theme/colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider).value!;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacings.screenHorizontal,
          vertical: 16,
        ),
        children: [
          _buildSectionHeader('Appearance'),
          Card(
            child: SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Toggle app theme'),
              value: settings.isDarkMode,
              onChanged: (v) => ref.read(settingsControllerProvider.notifier).toggleDarkMode(v),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Storage'),
          Card(
            child: SwitchListTile(
              title: const Text('Auto-delete Files'),
              subtitle: const Text('Remove input file after conversion'),
              value: settings.autoDeleteFiles,
              onChanged: (v) => ref.read(settingsControllerProvider.notifier).toggleAutoDelete(v),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('About'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Version'),
                  trailing: const Text('1.0.0'),
                ),
                Divider(height: 1, color: AppColors.slate200),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.slate500,
        ),
      ),
    );
  }
}