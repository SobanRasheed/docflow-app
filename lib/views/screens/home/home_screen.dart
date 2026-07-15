import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../controllers/home_controller.dart';
import '../../../core/theme/colors.dart';
import '../../../models/tool_type.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/tool_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toolsAsync = ref.watch(homeControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'lib/assets/logo.svg',
          height: 48,
        ),
        centerTitle: false,
      ),
      body: toolsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (tools) => ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacings.screenHorizontal,
            vertical: 8,
          ),
          children: [
            Text(
              'Premium document tools',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Fast, secure, and easy to use.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.slate500,
                  ),
            ),
            const SizedBox(height: 24),
            _buildPromoCard(context),
            const SizedBox(height: 24),
            _buildSection(context, 'Convert', tools, ToolCategory.convert),
            const SizedBox(height: 24),
            _buildSection(context, 'Organize', tools, ToolCategory.organize),
            const SizedBox(height: 24),
            _buildSection(context, 'Optimize', tools, ToolCategory.optimize),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.brand600, AppColors.brand800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacings.cardRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unlock Pro',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Unlimited conversions & larger file sizes.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.bolt, size: 16),
                  label: const Text('Upgrade'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.brand800,
                    minimumSize: const Size.fromHeight(0),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.workspace_premium, color: Colors.white70, size: 48),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<ToolType> allTools,
    ToolCategory category,
  ) {
    final tools = allTools.where((t) => t.category == category).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12, top: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacings.gridGap,
            crossAxisSpacing: AppSpacings.gridGap,
            childAspectRatio: 1.0,
          ),
          itemCount: tools.length,
          itemBuilder: (context, index) => ToolTile(tool: tools[index]),
        ),
      ],
    );
  }
}