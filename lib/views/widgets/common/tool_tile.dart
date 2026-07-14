import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../../models/tool_type.dart';
import '../../../routes/route_names.dart';

class ToolTile extends StatelessWidget {
  const ToolTile({super.key, required this.tool});
  final ToolType tool;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => context.go('/upload/${tool.id}'),
        borderRadius: BorderRadius.circular(AppSpacings.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacings.card),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacings.iconRadius),
                decoration: BoxDecoration(
                  color: tool.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacings.iconRadius),
                ),
                child: Icon(tool.icon, color: tool.color),
              ),
              const Spacer(),
              Text(
                tool.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                tool.subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.slate500,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}