import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../config/tokens.dart';
import '../logic/game_state.dart';
import '../logic/tetromino.dart';

class GameBoard extends StatefulWidget {
  final GameState state;
  final bool flashClear;

  const GameBoard({super.key, required this.state, required this.flashClear});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  final Random _random = Random();
  Timer? _particleTimer;
  int _lastClearEventId = 0;
  List<_ClearParticle> _particles = const [];
  double _particleProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _lastClearEventId = widget.state.clearEventId;
  }

  @override
  void didUpdateWidget(covariant GameBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final clearEventChanged = widget.state.clearEventId != _lastClearEventId;
    if (!clearEventChanged) return;

    _lastClearEventId = widget.state.clearEventId;
    if (widget.state.lastClearCount > 0) {
      _startCrumble(widget.state.lastClearedRows);
    }
  }

  @override
  void dispose() {
    _particleTimer?.cancel();
    super.dispose();
  }

  void _startCrumble(List<int> clearedRows) {
    _particleTimer?.cancel();
    final particles = <_ClearParticle>[];
    for (final row in clearedRows) {
      for (var x = 0; x < AppConstants.boardWidth; x++) {
        for (var i = 0; i < AppConstants.clearParticlesPerCell; i++) {
          particles.add(
            _ClearParticle(
              x: x + _random.nextDouble(),
              y: row + _random.nextDouble(),
              vx: (_random.nextDouble() - 0.5) * 0.35,
              vy: 0.35 + _random.nextDouble() * 0.8,
              sizeFactor: 0.18 + _random.nextDouble() * 0.18,
            ),
          );
        }
      }
    }

    if (particles.isEmpty) return;

    setState(() {
      _particles = particles;
      _particleProgress = 0.0;
    });

    final startedAt = DateTime.now();
    _particleTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      final elapsedMs = DateTime.now().difference(startedAt).inMilliseconds;
      final progress = elapsedMs / AppConstants.clearParticleDurationMs;
      if (progress >= 1.0) {
        timer.cancel();
        if (!mounted) return;
        setState(() {
          _particles = const [];
          _particleProgress = 0.0;
        });
        return;
      }
      if (!mounted) return;
      setState(() {
        _particleProgress = progress;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: AppConstants.boardWidth / AppConstants.boardHeight,
      child: Stack(
        children: [
          CustomPaint(
            painter: _BoardPainter(
              state: widget.state,
              particles: _particles,
              particleProgress: _particleProgress,
            ),
            size: Size.infinite,
          ),
          AnimatedOpacity(
            opacity: widget.flashClear ? 0.35 : 0.0,
            duration: AppDurations.quick,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.lobbyPrimary,
                borderRadius: BorderRadius.circular(AppRadii.md),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClearParticle {
  final double x;
  final double y;
  final double vx;
  final double vy;
  final double sizeFactor;

  const _ClearParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.sizeFactor,
  });
}

class _BoardPainter extends CustomPainter {
  final GameState state;
  final List<_ClearParticle> particles;
  final double particleProgress;

  _BoardPainter({
    required this.state,
    required this.particles,
    required this.particleProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / AppConstants.boardWidth;
    final cellHeight = size.height / AppConstants.boardHeight;

    final paintSettled = Paint()
      ..color = AppColors.lobbyPrimary
      ..style = PaintingStyle.fill;

    final paintSettledEdge = Paint()
      ..color = AppColors.backgroundPrimary.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final paintBorder = Paint()
      ..color = AppColors.lobbyPrimary.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppBorders.thin;

    final paintActive = Paint()
      ..color = AppColors.textPrimary
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = AppColors.textPrimary.withOpacity(0.6)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        AppEffects.glowRadius,
      );

    for (var y = 0; y < AppConstants.boardHeight; y++) {
      for (var x = 0; x < AppConstants.boardWidth; x++) {
        final left = x * cellWidth;
        final top = y * cellHeight;
        final rect = Rect.fromLTWH(left, top, cellWidth, cellHeight);
        if (state.grid[y][x] != null) {
          canvas.drawRect(rect, paintSettled);
          canvas.drawRect(rect, paintSettledEdge);
        }
      }
    }

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paintBorder);

    final tetromino = _activeTetromino();
    for (final cell in tetromino.cells(state.rotation)) {
      final x = state.activePosition.x + cell.x;
      final y = state.activePosition.y + cell.y;
      if (x < 0 ||
          x >= AppConstants.boardWidth ||
          y < 0 ||
          y >= AppConstants.boardHeight) {
        continue;
      }
      final left = x * cellWidth;
      final top = y * cellHeight;
      final rect = Rect.fromLTWH(left, top, cellWidth, cellHeight);
      canvas.drawRect(rect, glowPaint);
      canvas.drawRect(rect, paintActive);
      canvas.drawRect(rect, paintBorder);
    }

    if (particles.isNotEmpty) {
      final fade = (1.0 - particleProgress).clamp(0.0, 1.0);
      final particlePaint = Paint()
        ..color = AppColors.lobbyPrimary.withOpacity(fade)
        ..style = PaintingStyle.fill;
      for (final particle in particles) {
        final px = (particle.x + (particle.vx * particleProgress)) * cellWidth;
        final py = (particle.y + (particle.vy * particleProgress)) * cellHeight;
        final side =
            min(cellWidth, cellHeight) *
            particle.sizeFactor *
            (0.85 + (0.15 * fade));
        canvas.drawRect(
          Rect.fromCenter(center: Offset(px, py), width: side, height: side),
          particlePaint,
        );
      }
    }
  }

  Tetromino _activeTetromino() {
    switch (state.activeType) {
      case TetrominoType.I:
        return TetrominoLibrary.i;
      case TetrominoType.O:
        return TetrominoLibrary.o;
      case TetrominoType.T:
        return TetrominoLibrary.t;
      case TetrominoType.S:
        return TetrominoLibrary.s;
      case TetrominoType.Z:
        return TetrominoLibrary.z;
      case TetrominoType.J:
        return TetrominoLibrary.j;
      case TetrominoType.L:
        return TetrominoLibrary.l;
    }
  }

  @override
  bool shouldRepaint(covariant _BoardPainter oldDelegate) {
    return oldDelegate.state != state ||
        oldDelegate.particleProgress != particleProgress ||
        oldDelegate.particles.length != particles.length;
  }
}
