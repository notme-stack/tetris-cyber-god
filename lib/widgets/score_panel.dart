import 'package:flutter/material.dart';
import '../config/tokens.dart';
import 'app_card.dart';

class ScorePanel extends StatelessWidget {
  final int score;

  const ScorePanel({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SCORE', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.xs),
          Text('$score', style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    );
  }
}
