import 'package:flutter/material.dart';
import '../../config/tokens.dart';
import '../../widgets/primary_button.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final String duration;
  final int peakLevel;

  const ResultScreen({
    super.key,
    required this.score,
    required this.duration,
    required this.peakLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.aftermathBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = (constraints.maxHeight / 900).clamp(0.85, 1.0);
            return Stack(
              children: [
                Positioned.fill(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Opacity(
                        opacity: 0.4,
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBQY_H_yWWHq630kxPkk8rzhVyx5tzItIwsl-bzP2_fSEhQpQXPDwibCFhtcivjRMHSoBXO1SqNRR2DL-kxA_wscm3xN4O2t8PxsYvhjJn7y82PLWVFTvzi9B470gEXnXGARgtd9q4OysLdAgK2WbewKAeoWm-fH1vgsqD3senln134LzsAYcc6v6PZKnkciwOCndpqieoAQLhB_TlUVad4OEAnCvxBJO4FT4rUKEcXW_sVBxe-e5V96nZEK5Ax-eiqYdiiTH3SeYk',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.aftermathBackground.withOpacity(0.0),
                              AppColors.aftermathBackground,
                            ],
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _ScanlinePainter(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.md * scale,
                    AppSpacing.md * scale,
                    AppSpacing.md * scale,
                    AppSpacing.md * scale,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.md * scale,
                              vertical: AppSpacing.xs * scale,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.aftermathOverlay,
                              borderRadius: BorderRadius.circular(AppRadii.pill),
                              border: Border.all(
                                color: AppColors.aftermathPanelBorder,
                                width: AppBorders.thin,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: AppColors.stateDanger,
                                  size: 14 * scale,
                                ),
                                SizedBox(width: AppSpacing.xs * scale),
                                Text(
                                  'SYSTEM STATUS',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontSize: AppTypography.tiny * scale,
                                        letterSpacing: 2,
                                        color: AppColors.aftermathTextMutedAlt,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: AppSpacing.md * scale),
                          _GlitchText(text: 'PROTOCOL\nFAILED', scale: scale),
                        ],
                      ),
                      SizedBox(height: AppSpacing.md * scale),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(bottom: AppSpacing.sm * scale),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.aftermathPanel,
                                  borderRadius: BorderRadius.circular(AppRadii.xl),
                                  border: Border.all(color: AppColors.aftermathPanelBorder),
                                ),
                                child: Column(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(AppRadii.xl),
                                          ),
                                          image: const DecorationImage(
                                            image: NetworkImage(
                                              'https://lh3.googleusercontent.com/aida-public/AB6AXuBWWiAH4R8Ga2yoxNgUVbSz9Uuqv9K69MZ4HtS3HS5u7YNUTUesPX8-HnZ6kW_i_HfjnXa3AtLw-34IsmiIfLAFsnVqOQEzVrTKV5G0knADHAYDZKY7HaGqYpHqPYv8AcMtlgtLQdqgLDUHG2fh9II7VHWPTG9weiXAHGUZ4v6ifMhzl_lh_cNhQyXglcEuP_9JZsbaCbFvfWRFshEucdOCgSByYUxltB7WUjh6KCPx_vW6Tc95UxppB_QchSxAAlIKTDnRzhcy6kU',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(AppSpacing.md * scale),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'MISSION STATS',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            color: AppColors.aftermathPrimary,
                                                            fontSize: AppTypography.tiny * scale,
                                                            fontWeight: FontWeight.w700,
                                                            letterSpacing: 2,
                                                          ),
                                                    ),
                                                    SizedBox(height: AppSpacing.xs * scale),
                                                    Text(
                                                      _formatScore(score),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium
                                                          ?.copyWith(
                                                            fontSize: 30 * scale,
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                    ),
                                                    SizedBox(height: AppSpacing.xs * scale),
                                                    Text(
                                                      'Final System Score',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            color: AppColors.aftermathTextMuted,
                                                            fontSize: AppTypography.small * scale,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 40 * scale,
                                                height: 40 * scale,
                                                decoration: BoxDecoration(
                                                  color: AppColors.aftermathPrimarySoft,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: AppColors.aftermathPrimaryBorder),
                                                ),
                                                child: const Icon(
                                                  Icons.leaderboard,
                                                  color: AppColors.aftermathPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: AppSpacing.sm * scale),
                                          Container(height: 1, color: AppColors.aftermathPanelBorder),
                                          SizedBox(height: AppSpacing.sm * scale),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'STABILITY',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            color: AppColors.aftermathTextMuted,
                                                            fontSize: AppTypography.tiny * scale,
                                                            fontWeight: FontWeight.w700,
                                                            letterSpacing: 1.5,
                                                          ),
                                                    ),
                                                    SizedBox(height: AppSpacing.xs * scale),
                                                    Text(
                                                      'LEVEL $peakLevel PEAK',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            fontSize: AppTypography.titleSize * scale,
                                                            fontStyle: FontStyle.italic,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      'DURATION',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            color: AppColors.aftermathTextMuted,
                                                            fontSize: AppTypography.tiny * scale,
                                                            fontWeight: FontWeight.w700,
                                                            letterSpacing: 1.5,
                                                          ),
                                                    ),
                                                    SizedBox(height: AppSpacing.xs * scale),
                                                    Text(
                                                      duration,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            fontSize: AppTypography.titleSize * scale,
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: AppSpacing.sm * scale),
                              Container(
                                padding: EdgeInsets.all(AppSpacing.md * scale),
                                decoration: BoxDecoration(
                                  color: AppColors.aftermathPrimarySoft,
                                  borderRadius: BorderRadius.circular(AppRadii.xl),
                                  border: Border.all(color: AppColors.aftermathPrimary.withOpacity(0.5)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 8 * scale,
                                          height: 8 * scale,
                                          decoration: const BoxDecoration(
                                            color: AppColors.aftermathPrimary,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: AppSpacing.sm * scale),
                                        Text(
                                          'AI OVERSEER',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: AppColors.aftermathPrimary,
                                                letterSpacing: 2,
                                                fontWeight: FontWeight.w700,
                                                fontSize: AppTypography.small * scale,
                                              ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: AppSpacing.xs * scale),
                                    Text(
                                      '"Predictable placement. Try again, human."',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            fontStyle: FontStyle.italic,
                                            fontSize: AppTypography.titleSize * scale,
                                            color: AppColors.textPrimary.withOpacity(0.9),
                                          ),
                                    ),
                                    SizedBox(height: AppSpacing.sm * scale),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 4 * scale,
                                            width: 32 * scale,
                                            decoration: BoxDecoration(
                                              color: AppColors.aftermathPrimary.withOpacity(0.4),
                                              borderRadius: BorderRadius.circular(AppRadii.pill),
                                            ),
                                          ),
                                          SizedBox(width: AppSpacing.xs * scale),
                                          Container(
                                            height: 4 * scale,
                                            width: 8 * scale,
                                            decoration: BoxDecoration(
                                              color: AppColors.aftermathPrimary.withOpacity(0.4),
                                              borderRadius: BorderRadius.circular(AppRadii.pill),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs * scale),
                      PrimaryButton(
                        label: 'RE-INITIATE',
                        isEmphasized: true,
                        backgroundColor: AppColors.aftermathPrimary,
                        foregroundColor: AppColors.textPrimary,
                        borderColor: AppColors.aftermathPrimary,
                        onPressed: () => Navigator.of(context).pushReplacementNamed('/arena'),
                      ),
                      SizedBox(height: AppSpacing.xs * scale),
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pushReplacementNamed('/lobby'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: AppSpacing.md * scale),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadii.pill),
                          ),
                          side: BorderSide(color: AppColors.aftermathPanelBorder),
                          foregroundColor: AppColors.aftermathTextMutedAlt,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.home, size: 18),
                            SizedBox(width: AppSpacing.sm * scale),
                            Text(
                              'BACK TO LOBBY',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    letterSpacing: 3,
                                    fontSize: AppTypography.small * scale,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GlitchText extends StatelessWidget {
  final String text;
  final double scale;

  const _GlitchText({required this.text, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 44 * scale,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
                color: AppColors.aftermathCyanGlitch,
              ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 44 * scale,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
                color: AppColors.aftermathPrimary,
              ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 44 * scale,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
        ),
      ],
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.08)
      ..strokeWidth = 1;
    for (double y = 0; y < size.height; y += 2) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

String _formatScore(int score) {
  final value = score.toString();
  if (value.length <= 3) return value;
  final buffer = StringBuffer();
  for (var i = 0; i < value.length; i++) {
    final remaining = value.length - i;
    buffer.write(value[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}
