import 'package:flutter/material.dart';

import '../../config/tokens.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale =
                (constraints.maxHeight / 900).clamp(0.72, 1.0) *
                (constraints.maxWidth / 420).clamp(0.88, 1.0);
            final horizontalPad = AppSpacing.md * scale;
            final titleSize = 18.0 * scale;
            final ringSize = constraints.maxWidth * 0.62;
            return Stack(
              children: [
                const Positioned.fill(child: _ScanlineLayer()),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPad,
                    AppSpacing.md * scale,
                    horizontalPad,
                    AppSpacing.sm * scale,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          _ProtocolIcon(scale: scale),
                          SizedBox(width: AppSpacing.sm * scale),
                          Expanded(
                            child: Text(
                              'PROTOCOL: GRID_ACCESS_V2',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppColors.accentPlayer,
                                    letterSpacing: 3.2 * scale,
                                    fontSize: titleSize,
                                    fontWeight: FontWeight.w700,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.lg * scale),
                      Container(
                        padding: EdgeInsets.all(AppSpacing.md * scale),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(AppRadii.xl),
                          border: Border.all(
                            color: AppColors.accentPlayer.withOpacity(0.5),
                            width: AppBorders.thin,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 10 * scale,
                                  height: 10 * scale,
                                  decoration: const BoxDecoration(
                                    color: AppColors.accentEnemy,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: AppSpacing.sm * scale),
                                Text(
                                  'KERNEL LOG: ACTIVE_SESSION',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: AppColors.accentPlayer
                                            .withOpacity(0.85),
                                        letterSpacing: 2.0 * scale,
                                        fontSize:
                                            AppTypography.bodySize * scale,
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSpacing.sm * scale),
                            Container(
                              height: AppBorders.thin,
                              color: AppColors.accentPlayer.withOpacity(0.35),
                            ),
                            SizedBox(height: AppSpacing.md * scale),
                            Center(
                              child: Text(
                                'GRID PATTERN RECOGNIZED.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: AppColors.accentPlayer,
                                      fontSize: 18 * scale,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ),
                            SizedBox(height: AppSpacing.sm * scale),
                            Center(
                              child: Text(
                                'CLEARING LINES FOR SECURE UPLINK...',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: AppColors.accentEnemy,
                                      fontSize: 14 * scale,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Center(
                        child: SizedBox(
                          width: ringSize,
                          height: ringSize,
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: ringSize,
                                height: ringSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.accentPlayer.withOpacity(
                                      0.12,
                                    ),
                                    width: AppBorders.thin,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: -18 * scale,
                                top: ringSize * 0.22,
                                child: _TelemetryLabel(
                                  line1: 'STATE: PAUSED',
                                  line2: 'SEQUENCE: 0X442',
                                  scale: scale,
                                ),
                              ),
                              Positioned(
                                right: -16 * scale,
                                top: ringSize * 0.22,
                                child: _TelemetryLabel(
                                  line1: 'NEXT: Z_PIECE',
                                  line2: 'LINE_CLEAR: 2',
                                  alignRight: true,
                                  scale: scale,
                                ),
                              ),
                              _LinkButton(
                                scale: scale,
                                onTap: () => Navigator.of(
                                  context,
                                ).pushReplacementNamed('/lobby'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.md * scale),
                      Text(
                        'CLICK HERE TO ENTER',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMuted.withOpacity(0.8),
                          letterSpacing: 4 * scale,
                          fontSize: AppTypography.bodySize * scale,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: _InfoChip(
                              label: 'ENCRYPTION',
                              value: 'BYPASSED',
                              scale: scale,
                              accent: AppColors.accentPlayer,
                            ),
                          ),
                          SizedBox(width: AppSpacing.sm * scale),
                          Expanded(
                            child: _InfoChip(
                              label: 'USER',
                              value: 'GUEST',
                              scale: scale,
                              accent: AppColors.accentPlayer,
                            ),
                          ),
                          SizedBox(width: AppSpacing.sm * scale),
                          Expanded(
                            child: _InfoChip(
                              label: 'SYSTEM',
                              value: 'ONLINE',
                              scale: scale,
                              accent: AppColors.accentEnemy,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.md * scale),
                      Container(
                        height: AppBorders.thin,
                        color: AppColors.accentPlayer.withOpacity(0.15),
                      ),
                      SizedBox(height: AppSpacing.sm * scale),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _FooterLink(label: 'MANIFESTO', scale: scale),
                          _FooterLink(label: 'SYSTEM SPECS', scale: scale),
                          _FooterLink(label: 'GHOST MODE', scale: scale),
                        ],
                      ),
                      SizedBox(height: AppSpacing.sm * scale),
                      Text(
                        '[!] TETRIS_GRID_ACTIVE: Z-BLOCK READY AT INDEX_0. DISSOLVE IN PROGRESS.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.accentEnemy.withOpacity(0.85),
                          fontSize: AppTypography.small * scale,
                          letterSpacing: 0.8 * scale,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppSpacing.xs * scale),
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

class _ProtocolIcon extends StatelessWidget {
  final double scale;

  const _ProtocolIcon({required this.scale});

  @override
  Widget build(BuildContext context) {
    final side = 10 * scale;
    return SizedBox(
      width: 24 * scale,
      height: 24 * scale,
      child: Wrap(
        spacing: 2 * scale,
        runSpacing: 2 * scale,
        children: List.generate(
          4,
          (_) => Container(
            width: side,
            height: side,
            color: AppColors.accentPlayer,
          ),
        ),
      ),
    );
  }
}

class _TelemetryLabel extends StatelessWidget {
  final String line1;
  final String line2;
  final bool alignRight;
  final double scale;

  const _TelemetryLabel({
    required this.line1,
    required this.line2,
    required this.scale,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontSize: AppTypography.small * scale,
        letterSpacing: 1.4 * scale,
        color: alignRight
            ? AppColors.accentEnemy.withOpacity(0.9)
            : AppColors.accentPlayer.withOpacity(0.9),
      ),
      child: Column(
        crossAxisAlignment: alignRight
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(line1),
          SizedBox(height: AppSpacing.xs * scale),
          Text(line2),
        ],
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final VoidCallback onTap;
  final double scale;

  const _LinkButton({required this.onTap, required this.scale});

  @override
  Widget build(BuildContext context) {
    final buttonSize = 252.0 * scale;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.6),
          border: Border.all(
            color: AppColors.accentPlayer.withOpacity(0.9),
            width: 6 * scale.clamp(0.8, 1.0),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentPlayer.withOpacity(0.35),
              blurRadius: 24 * scale,
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.all(14 * scale),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.accentPlayer.withOpacity(0.25),
              width: AppBorders.thin,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ProtocolIcon(scale: 1.1 * scale),
              SizedBox(height: AppSpacing.md * scale),
              Text(
                'ESTABLISH LINK',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.accentPlayer,
                  letterSpacing: 4.0 * scale,
                  fontWeight: FontWeight.w700,
                  fontSize: 16 * scale,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final double scale;
  final Color accent;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.scale,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm * scale,
        vertical: AppSpacing.md * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(
          color: accent.withOpacity(0.45),
          width: AppBorders.thin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: accent.withOpacity(0.8),
              fontSize: AppTypography.bodySize * scale,
              letterSpacing: 1.2 * scale,
            ),
          ),
          SizedBox(height: AppSpacing.xs * scale),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontSize: 18 * scale,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final double scale;

  const _FooterLink({required this.label, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppColors.accentPlayer.withOpacity(0.6),
        letterSpacing: 2.2 * scale,
        fontSize: AppTypography.bodySize * scale,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _ScanlineLayer extends StatelessWidget {
  const _ScanlineLayer();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ScanlinePainter(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundPrimary,
              AppColors.backgroundPrimary.withOpacity(0.96),
              AppColors.backgroundPrimary,
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final horizontal = Paint()
      ..color = AppColors.accentPlayer.withOpacity(0.035)
      ..strokeWidth = 1;
    final vertical = Paint()
      ..color = AppColors.accentEnemy.withOpacity(0.03)
      ..strokeWidth = 1;

    for (double y = 0; y < size.height; y += 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), horizontal);
    }
    for (double x = 0; x < size.width; x += 4) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), vertical);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
