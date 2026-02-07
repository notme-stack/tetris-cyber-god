import 'dart:async';
import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../config/tokens.dart';
import '../../widgets/app_card.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0;
  Timer? _progressTimer;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _progressTimer = Timer.periodic(AppDurations.quick, (timer) {
      if (!mounted) return;
      setState(() {
        _progress = (_progress + 0.05).clamp(0.0, 1.0);
      });
    });
    _navTimer = Timer(const Duration(milliseconds: AppConstants.bootTotalMs), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/lobby');
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _navTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text(
                'INITIALISING LINK',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.accentPlayer),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'HANDSHAKE',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(AppRadii.md),
                        border: Border.all(color: AppColors.accentPlayer, width: AppBorders.thin),
                      ),
                      child: const Icon(Icons.grid_4x4, color: AppColors.accentPlayer, size: 48),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'SECURE_NODE: v4.2.1',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                'ESTABLISHING PROTOCOL',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: AppColors.surfaceSecondary,
                valueColor: const AlwaysStoppedAnimation(AppColors.accentPlayer),
                minHeight: AppSpacing.sm,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('SYSTEM BOOT IN PROGRESS', style: Theme.of(context).textTheme.bodyMedium),
                  Text('${(_progress * 100).round()}%', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
