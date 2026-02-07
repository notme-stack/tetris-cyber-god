import 'package:flutter/material.dart';
import '../config/tokens.dart';
import 'app_card.dart';
import 'primary_button.dart';

class ResultModal extends StatelessWidget {
  final String title;
  final String subtitle;
  final String primaryActionLabel;
  final VoidCallback onPrimaryAction;

  const ResultModal({
    super.key,
    required this.title,
    required this.subtitle,
    required this.primaryActionLabel,
    required this.onPrimaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacing.lg),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(label: primaryActionLabel, onPressed: onPrimaryAction),
          ],
        ),
      ),
    );
  }
}
