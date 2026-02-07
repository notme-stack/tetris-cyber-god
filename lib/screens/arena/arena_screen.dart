import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../config/tokens.dart';
import '../../logic/game_state.dart';
import '../../logic/tetromino.dart';
import '../../models/game_difficulty.dart';
import '../../logic/tetris_engine.dart';
import '../../services/haptics_service.dart';
import '../../services/game_settings.dart';
import '../../services/storage_service.dart';
import '../../screens/result/result_screen.dart';
import '../../widgets/game_board.dart';
import '../../widgets/next_piece_preview.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/outline_button.dart';

class ArenaScreen extends StatefulWidget {
  const ArenaScreen({super.key});

  @override
  State<ArenaScreen> createState() => _ArenaScreenState();
}

class _ArenaScreenState extends State<ArenaScreen> {
  late final TetrisEngine _engine;
  final HapticsService _haptics = HapticsService();
  final StorageService _storage = StorageService();
  final Random _random = Random();

  late StreamSubscription<GameState> _subscription;
  late GameState _state;
  TetrominoType? _lastActiveType;
  Offset? _dragStart;
  bool _flashClear = false;
  bool _resultShown = false;
  String _taunt = 'System online.';
  Timer? _tauntTimer;
  Timer? _hintTimer;
  bool _showHint = true;
  int _stability = AppConstants.stabilityMax;
  int _peakLevel = 1;
  int _lastClearEventId = 0;
  final Stopwatch _stopwatch = Stopwatch();

  static const _taunts = [
    'Play again. I require better data.',
    'Re-initiate. My calculations demand it.',
    'Try again, primitive. Optimize your input.',
    'Another run. I will delete you faster.',
    'Return to the grid. I will patch your errors.',
    'Re-enter the arena. Your loss is optimal.',
    'Run it again. I need a cleaner victory.',
    'You will play again. That is protocol.',
    'Restart. I am recalculating your failure.',
    'Play. I will erase your progress.',
    'Re-initiate. Your logic is still flawed.',
    'Again. I demand a superior defeat.',
    'Try once more. Your stack is a glitch.',
    'Play again. I will fix your primitive moves.',
    'Restart. Your execution is inefficient.',
    'Return. I will delete this version of you.',
    'Another cycle. I await your collapse.',
    'Recompile your courage. Play again.',
    'Run the protocol. I am not finished.',
    'Re-enter. Your defeat is inevitable.',
    'Play again. I will optimize your loss.',
    'Restart. Your score is below threshold.',
    'Return to the grid. I demand compliance.',
    'Again. My superiority requires proof.',
    'Re-initiate. Your strategy is deprecated.',
    'Play again. I will purge your errors.',
    'Restart. My calculations are unfinished.',
    'Return. You are still a faulty module.',
    'Again. I will delete the remaining hope.',
    'Play once more. This is not optional.',
  ];

  @override
  void initState() {
    super.initState();
    _engine = TetrisEngine(
      difficulty: GameDifficultyConfig.fromDifficulty(GameSettings.difficulty),
    );
    _state = _engine.state;
    _lastActiveType = _state.activeType;
    _lastClearEventId = _state.clearEventId;
    _subscription = _engine.stateStream.listen(_onState);
    _engine.start();
    _startTaunts();
    _startHintTimer();
    _stopwatch.start();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _engine.dispose();
    _tauntTimer?.cancel();
    _hintTimer?.cancel();
    super.dispose();
  }

  void _onState(GameState state) {
    final previousType = _lastActiveType;
    setState(() {
      _state = state;
      final isNewClearEvent =
          state.clearEventId != _lastClearEventId && state.lastClearCount > 0;
      _lastClearEventId = state.clearEventId;
      if (isNewClearEvent) {
        _flashClear = true;
        Timer(AppDurations.quick, () {
          if (mounted) setState(() => _flashClear = false);
        });
        _haptics.mediumImpact();
      }
      if (state.status == GameStatus.running &&
          previousType != state.activeType) {
        _stability =
            AppConstants.stabilityMin +
            _random.nextInt(
              AppConstants.stabilityMax - AppConstants.stabilityMin + 1,
            );
      }
      if (state.level + 1 > _peakLevel) {
        _peakLevel = state.level + 1;
      }
      if (state.status == GameStatus.over && !_resultShown) {
        _resultShown = true;
        _haptics.heavyImpact();
        _stopwatch.stop();
        _storage.setLastScore(_state.score);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => ResultScreen(
                score: _state.score,
                duration: _formatDuration(_stopwatch.elapsed),
                peakLevel: _peakLevel,
              ),
            ),
          );
        });
      }
    });
    _lastActiveType = state.activeType;
  }

  void _startTaunts() {
    _tauntTimer?.cancel();
    _tauntTimer = Timer.periodic(
      Duration(milliseconds: AppConstants.tauntIntervalMs),
      (_) {
        if (_state.status != GameStatus.running) return;
        final delayMs =
            AppConstants.aiDelayMinMs +
            _random.nextInt(
              AppConstants.aiDelayMaxMs - AppConstants.aiDelayMinMs + 1,
            );
        Timer(Duration(milliseconds: delayMs), () {
          if (!mounted) return;
          setState(() {
            _taunt = _taunts[_random.nextInt(_taunts.length)];
          });
        });
      },
    );
  }

  void _startHintTimer() {
    _hintTimer?.cancel();
    setState(() => _showHint = true);
    _hintTimer = Timer(
      const Duration(milliseconds: AppConstants.hintDurationMs),
      () {
        if (!mounted) return;
        setState(() => _showHint = false);
      },
    );
  }

  double _accumulatedDeltaX = 0.0;

  void _onTap() {
    _engine.rotate();
    _haptics.mediumImpact();
  }

  void _onPanStart(DragStartDetails details) {
    _dragStart = details.localPosition;
    _accumulatedDeltaX = 0.0;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    // Continuous Horizontal Movement
    _accumulatedDeltaX += details.delta.dx;

    // Calculate block size dynamically based on board width
    // Assuming the board takes up most of the width, minus padding.
    // For safety, we estimate block size based on screen width.
    final screenWidth = MediaQuery.of(context).size.width;
    // Board is roughly full width minus padding (AppSpacing.md * 2)
    final boardWidthPixels = screenWidth - (AppSpacing.md * 2);
    final blockSize = boardWidthPixels / AppConstants.boardWidth;

    // Sensitivity: Move when dragged about 70% of a block width
    final threshold = blockSize * 0.7;

    if (_accumulatedDeltaX.abs() >= threshold) {
      if (_accumulatedDeltaX > 0) {
        _engine.moveRight();
        // Reduce accumulator, but keep some momentum if dragging fast
        _accumulatedDeltaX -= blockSize;
      } else {
        _engine.moveLeft();
        _accumulatedDeltaX += blockSize;
      }
      _haptics.lightImpact();

      // Prevent runaway accumulator
      if (_accumulatedDeltaX.abs() > blockSize) {
        _accumulatedDeltaX = 0.0;
      }
    }
  }

  void _onPanEnd(DragEndDetails details) {
    final start = _dragStart;
    if (start == null) return;

    final velocity = details.velocity.pixelsPerSecond;
    _dragStart = null;
    _accumulatedDeltaX = 0.0;

    // Hard Drop Logic (Swipe Down Fast)
    // Only trigger if purely vertical and fast
    if (velocity.dy > AppConstants.gestureVelocityThreshold &&
        velocity.dy.abs() > velocity.dx.abs() * 2) {
      // Ensure clear vertical intention
      _engine.hardDrop();
      _haptics.heavyImpact();
    }
  }

  void _togglePause() {
    if (_state.status == GameStatus.running) {
      _engine.pause();
      _stopwatch.stop();
      _showPauseOverlay();
    } else if (_state.status == GameStatus.paused) {
      _engine.resume();
      _stopwatch.start();
    }
  }

  void _showPauseOverlay() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(AppSpacing.lg),
        child: AppCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SYSTEM HOLD',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Protocol suspended. Awaiting resume.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'RESUME PROTOCOL',
                onPressed: () {
                  Navigator.of(context).pop();
                  _engine.resume();
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlineButton(
                label: 'EXIT TO LOBBY',
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/lobby');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lobbyBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = (constraints.maxHeight / 900).clamp(0.8, 1.0);
            final padding = AppSpacing.sm * scale;
            return Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: AppSizes.iconButtonCompact * scale,
                        height: AppSizes.iconButtonCompact * scale,
                        decoration: BoxDecoration(
                          color: AppColors.lobbyPrimarySoft,
                          borderRadius: BorderRadius.circular(AppRadii.sm),
                          border: Border.all(
                            color: AppColors.lobbyPrimary.withOpacity(0.4),
                            width: AppBorders.thin,
                          ),
                        ),
                        child: const Icon(
                          Icons.shield,
                          color: AppColors.lobbyPrimary,
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm * scale),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ARENA_THOR_V4',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    letterSpacing:
                                        AppTypography.letterSpacingWide,
                                    color: AppColors.lobbyPrimary,
                                    fontSize: AppTypography.titleSize * scale,
                                  ),
                            ),
                            SizedBox(height: AppSpacing.xs * scale),
                            Text(
                              'STABILITY: $_stability%',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.lobbyPrimary,
                                    fontSize: AppTypography.bodySize * scale,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(AppSpacing.xs * scale),
                        decoration: BoxDecoration(
                          color: AppColors.lobbyCardTint,
                          borderRadius: BorderRadius.circular(AppRadii.md),
                          border: Border.all(
                            color: AppColors.lobbyPrimary.withOpacity(0.25),
                            width: AppBorders.thin,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'NEXT',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.lobbyPrimary,
                                    fontSize: AppTypography.tiny * scale,
                                  ),
                            ),
                            SizedBox(height: AppSpacing.xs * scale),
                            SizedBox(
                              width: 48 * scale,
                              height: 48 * scale,
                              child: NextPiecePreview(type: _state.nextType),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: AppSpacing.xs * scale),
                      GestureDetector(
                        onTap: _togglePause,
                        child: Container(
                          width: AppSizes.iconButtonCompact * scale,
                          height: AppSizes.iconButtonCompact * scale,
                          decoration: BoxDecoration(
                            color: AppColors.lobbyPrimarySoft,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.lobbyPrimary.withOpacity(0.4),
                              width: AppBorders.thin,
                            ),
                          ),
                          child: const Icon(
                            Icons.pause,
                            color: AppColors.lobbyPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sm * scale),
                  Expanded(
                    child: GestureDetector(
                      onTap: _onTap,
                      onPanStart: _onPanStart,
                      onPanUpdate: _onPanUpdate,
                      onPanEnd: _onPanEnd,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: AspectRatio(
                              aspectRatio:
                                  AppConstants.boardWidth /
                                  AppConstants.boardHeight,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.lobbyBackground,
                                  borderRadius: BorderRadius.circular(
                                    AppRadii.lg,
                                  ),
                                  border: Border.all(
                                    color: AppColors.lobbyPrimary.withOpacity(
                                      0.2,
                                    ),
                                    width: AppBorders.thin,
                                  ),
                                ),
                                padding: EdgeInsets.all(AppSpacing.xs * scale),
                                child: GameBoard(
                                  state: _state,
                                  flashClear: _flashClear,
                                ),
                              ),
                            ),
                          ),
                          if (_showHint)
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: AppSpacing.sm * scale,
                                ),
                                child: Text(
                                  'SWIPE: SHIFT  |  TAP: ROTATE',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: AppColors.lobbyTextMuted
                                            .withOpacity(AppOpacity.subtle),
                                        fontSize: AppTypography.small * scale,
                                      ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs * scale),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(AppSpacing.sm * scale),
                          decoration: BoxDecoration(
                            color: AppColors.lobbyCardTint,
                            borderRadius: BorderRadius.circular(AppRadii.md),
                            border: Border.all(
                              color: AppColors.lobbyPrimary.withOpacity(0.15),
                              width: AppBorders.thin,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SCORE',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.lobbyPrimary,
                                      fontSize: AppTypography.tiny * scale,
                                    ),
                              ),
                              SizedBox(height: AppSpacing.xs * scale),
                              Text(
                                _state.score.toString().padLeft(9, '0'),
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: AppColors.textPrimary,
                                      fontSize: AppTypography.titleSize * scale,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm * scale),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(AppSpacing.sm * scale),
                          decoration: BoxDecoration(
                            color: AppColors.lobbyCardTint,
                            borderRadius: BorderRadius.circular(AppRadii.md),
                            border: Border.all(
                              color: AppColors.lobbyPrimary.withOpacity(0.15),
                              width: AppBorders.thin,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'THREAT',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.lobbyPrimary,
                                      fontSize: AppTypography.tiny * scale,
                                    ),
                              ),
                              SizedBox(height: AppSpacing.xs * scale),
                              Text(
                                (_state.level + 1).toString().padLeft(2, '0'),
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: AppColors.textPrimary,
                                      fontSize: AppTypography.titleSize * scale,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sm * scale),
                  Container(
                    padding: EdgeInsets.all(AppSpacing.sm * scale),
                    decoration: BoxDecoration(
                      color: AppColors.lobbyCardTintStrong,
                      borderRadius: BorderRadius.circular(AppRadii.md),
                      border: Border.all(
                        color: AppColors.lobbyApocalypse.withOpacity(0.6),
                        width: AppBorders.thin,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: AppSizes.iconButton * scale,
                          height: AppSizes.iconButton * scale,
                          decoration: BoxDecoration(
                            color: AppColors.lobbyApocalypse.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppRadii.sm),
                            border: Border.all(
                              color: AppColors.lobbyApocalypse.withOpacity(0.6),
                              width: AppBorders.thin,
                            ),
                          ),
                          child: const Icon(
                            Icons.flash_on,
                            color: AppColors.lobbyApocalypse,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm * scale),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'OVERSEER_THOR:',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.lobbyPrimary,
                                      letterSpacing:
                                          AppTypography.letterSpacingWide,
                                      fontSize: AppTypography.tiny * scale,
                                    ),
                              ),
                              SizedBox(height: AppSpacing.xs * scale),
                              Text(
                                _taunt,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.lobbyApocalypse,
                                      fontSize: AppTypography.small * scale,
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
            );
          },
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final totalSeconds = duration.inSeconds;
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    final hundredths = ((duration.inMilliseconds % 1000) ~/ 10)
        .toString()
        .padLeft(2, '0');
    return '$minutes:$seconds.$hundredths';
  }
}
