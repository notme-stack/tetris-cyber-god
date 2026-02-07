import 'package:flutter/material.dart';
import '../config/tokens.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;

  const AppCard({
    super.key,
    required this.child,
    required this.padding,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surfacePrimary,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(
          color: borderColor ?? AppColors.surfaceSecondary,
          width: AppBorders.thin,
        ),
      ),
      child: child,
    );
  }
}
