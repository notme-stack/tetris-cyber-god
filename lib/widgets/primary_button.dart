import 'package:flutter/material.dart';
import '../config/tokens.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isEmphasized;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isEmphasized = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              backgroundColor ?? (isEmphasized ? AppColors.accentPlayer : AppColors.surfaceSecondary),
          foregroundColor:
              foregroundColor ?? (isEmphasized ? AppColors.backgroundPrimary : AppColors.textPrimary),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
            side: BorderSide(
              color: borderColor ?? (isEmphasized ? AppColors.accentPlayer : AppColors.surfaceSecondary),
              width: AppBorders.thin,
            ),
          ),
          elevation: 0,
        ),
        child: Text(label, style: Theme.of(context).textTheme.labelLarge),
      ),
    );
  }
}
