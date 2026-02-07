import 'package:flutter/material.dart';
import '../config/tokens.dart';
import 'app_card.dart';

class TauntBox extends StatelessWidget {
  final String taunt;
  final Widget? leading;

  const TauntBox({
    super.key,
    required this.taunt,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      borderColor: AppColors.accentEnemy,
      child: Row(
        children: [
          leading ??
              Container(
                width: AppSpacing.sm,
                height: AppSpacing.sm,
                decoration: const BoxDecoration(
                  color: AppColors.accentEnemy,
                  shape: BoxShape.circle,
                ),
              ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              taunt,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
