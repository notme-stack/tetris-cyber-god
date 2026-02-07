import 'dart:async';
import 'dart:math';

import '../config/constants.dart';
import '../models/position.dart';
import '../models/game_difficulty.dart';
import 'game_state.dart';
import 'tetromino.dart';

typedef GameStateListener = void Function(GameState state);

class TetrisEngine {
  final Random _random;
  final StreamController<GameState> _controller;
  final GameDifficultyConfig _difficulty;
  Timer? _timer;

  GameState _state;

  TetrisEngine({Random? random, GameDifficultyConfig? difficulty})
    : _random = random ?? Random(),
      _difficulty = difficulty ?? GameDifficultyConfig.safe,
      _controller = StreamController<GameState>.broadcast(),
      _state = _initialState();

  Stream<GameState> get stateStream => _controller.stream;

  GameState get state => _state;

  void start() {
    if (_state.status == GameStatus.running) return;
    _state = _state.copyWith(status: GameStatus.running);
    _emit();
    _startTimer();
  }

  void pause() {
    if (_state.status != GameStatus.running) return;
    _timer?.cancel();
    _state = _state.copyWith(status: GameStatus.paused);
    _emit();
  }

  void resume() {
    if (_state.status != GameStatus.paused) return;
    _state = _state.copyWith(status: GameStatus.running);
    _emit();
    _startTimer();
  }

  void reset() {
    _timer?.cancel();
    _state = _initialState();
    _emit();
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }

  void moveLeft() => _tryMove(-1, 0);

  void moveRight() => _tryMove(1, 0);

  void softDrop() => _tryMove(0, 1);

  void rotate() {
    if (_state.status != GameStatus.running) return;
    final nextRotation =
        (_state.rotation + 1) % _activeTetromino.rotations.length;

    // Standard Rotation System (SRS) simplified wall kicks
    // Try: Center -> Left -> Right -> Up -> Down -> Left-Up -> Right-Up
    const kicks = [
      Position(0, 0), // Basic rotation
      Position(-1, 0), // Kick left (against right wall)
      Position(1, 0), // Kick right (against left wall)
      Position(0, -1), // Kick up (against floor/stack)
      Position(-1, -1), // Kick left-up
      Position(1, -1), // Kick right-up
      Position(-2, 0), // Kick left 2 (for I piece)
      Position(2, 0), // Kick right 2 (for I piece)
    ];

    for (final kick in kicks) {
      final kickedPos = Position(
        _state.activePosition.x + kick.x,
        _state.activePosition.y + kick.y,
      );
      if (_canPlace(kickedPos, nextRotation)) {
        _state = _state.copyWith(
          rotation: nextRotation,
          activePosition: kickedPos,
        );
        _lockRequestTime = null; // Reset lock delay on rotation
        _emit();
        return;
      }
    }
  }

  void hardDrop() {
    if (_state.status != GameStatus.running) return;
    var position = _state.activePosition;
    while (_canPlace(Position(position.x, position.y + 1), _state.rotation)) {
      position = Position(position.x, position.y + 1);
    }
    _state = _state.copyWith(activePosition: position);
    _lockPiece();
  }

  DateTime? _lockRequestTime;
  static const _lockDelayDuration = Duration(milliseconds: 500);

  void tick() {
    if (_state.status != GameStatus.running) return;
    if (_canPlace(
      Position(_state.activePosition.x, _state.activePosition.y + 1),
      _state.rotation,
    )) {
      _state = _state.copyWith(
        activePosition: Position(
          _state.activePosition.x,
          _state.activePosition.y + 1,
        ),
      );
      _lockRequestTime = null; // Reset lock timer if we fell freely
      _emit();
    } else {
      // Piece has landed. Check lock delay.
      final now = DateTime.now();
      if (_lockRequestTime == null) {
        _lockRequestTime = now;
      } else if (now.difference(_lockRequestTime!) > _lockDelayDuration) {
        _lockPiece();
        _lockRequestTime = null;
      }
    }
  }

  void _tryMove(int dx, int dy) {
    if (_state.status != GameStatus.running) return;
    final next = Position(
      _state.activePosition.x + dx,
      _state.activePosition.y + dy,
    );
    if (_canPlace(next, _state.rotation)) {
      _state = _state.copyWith(activePosition: next);
      // Successful move resets lock delay (classic "infinity" rule behavior, simplified)
      _lockRequestTime = null;
      _emit();
    } else if (dy == 1) {
      // If soft drop failed (hit bottom), we treat it like a tick landing
      // But usually soft drop is manual. We can just let the next tick handle the lock.
      // Or we can start the lock timer here.
      if (_lockRequestTime == null) {
        _lockRequestTime = DateTime.now();
      }
    }
  }

  void _lockPiece() {
    final grid = _cloneGrid(_state.grid);
    for (final cell in _activeTetromino.cells(_state.rotation)) {
      final x = _state.activePosition.x + cell.x;
      final y = _state.activePosition.y + cell.y;
      if (y >= 0 &&
          y < AppConstants.boardHeight &&
          x >= 0 &&
          x < AppConstants.boardWidth) {
        grid[y][x] = _state.activeType;
      }
    }

    final clearedRows = _clearLines(grid);
    final cleared = clearedRows.length;
    final totalLines = _state.linesCleared + cleared;
    final nextLevel = totalLines ~/ AppConstants.linesPerLevel;
    final scoreGain = _scoreForLines(cleared) * (nextLevel + 1);

    final nextType = _state.nextType;
    final spawnPosition = Position(AppConstants.spawnX, 0);
    final nextRotation = 0;

    final nextState = _state.copyWith(
      grid: grid,
      activeType: nextType,
      nextType: _randomTetromino().type,
      rotation: nextRotation,
      activePosition: spawnPosition,
      linesCleared: totalLines,
      level: nextLevel,
      score: _state.score + scoreGain,
      lastClearCount: cleared,
      lastClearedRows: clearedRows,
      clearEventId: cleared > 0 ? _state.clearEventId + 1 : _state.clearEventId,
    );

    if (_canPlace(spawnPosition, nextRotation, stateOverride: nextState)) {
      _state = nextState;
      _emit();
      _restartTimer();
    } else {
      _timer?.cancel();
      _state = nextState.copyWith(status: GameStatus.over);
      _emit();
    }
  }

  int _scoreForLines(int lines) {
    switch (lines) {
      case 1:
        return AppConstants.scoreSingle;
      case 2:
        return AppConstants.scoreDouble;
      case 3:
        return AppConstants.scoreTriple;
      case 4:
        return AppConstants.scoreTetris;
      default:
        return 0;
    }
  }

  bool _canPlace(Position position, int rotation, {GameState? stateOverride}) {
    final state = stateOverride ?? _state;
    final grid = state.grid;
    for (final cell in _activeTetrominoFor(state).cells(rotation)) {
      final x = position.x + cell.x;
      final y = position.y + cell.y;
      if (x < 0 ||
          x >= AppConstants.boardWidth ||
          y >= AppConstants.boardHeight) {
        return false;
      }
      if (y >= 0 && grid[y][x] != null) {
        return false;
      }
    }
    return true;
  }

  List<int> _clearLines(List<List<TetrominoType?>> grid) {
    final clearedRows = <int>[];
    for (var y = AppConstants.boardHeight - 1; y >= 0; y--) {
      final isFull = grid[y].every((cell) => cell != null);
      if (isFull) {
        clearedRows.add(y);
        grid.removeAt(y);
        grid.insert(
          0,
          List<TetrominoType?>.filled(AppConstants.boardWidth, null),
        );
        y += 1;
      }
    }
    return clearedRows;
  }

  Tetromino _randomTetromino() {
    return TetrominoLibrary.all[_random.nextInt(TetrominoLibrary.all.length)];
  }

  Tetromino get _activeTetromino => _activeTetrominoFor(_state);

  Tetromino _activeTetrominoFor(GameState state) {
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

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      Duration(milliseconds: _currentIntervalMs()),
      (_) => tick(),
    );
  }

  void _restartTimer() {
    if (_state.status != GameStatus.running) return;
    _startTimer();
  }

  int _currentIntervalMs() {
    final speed =
        AppConstants.baseFallIntervalMs *
        pow(AppConstants.levelSpeedFactor, _state.level).toDouble() *
        _difficulty.fallSpeedFactor;
    return max(AppConstants.minFallIntervalMs, speed.round());
  }

  void _emit() {
    final ghost = _calculateGhostPosition();
    _state = _state.copyWith(ghostPosition: ghost);
    _controller.add(_state);
  }

  Position _calculateGhostPosition() {
    var position = _state.activePosition;
    while (_canPlace(Position(position.x, position.y + 1), _state.rotation)) {
      position = Position(position.x, position.y + 1);
    }
    return position;
  }

  static GameState _initialState() {
    final random = Random();
    final first =
        TetrominoLibrary.all[random.nextInt(TetrominoLibrary.all.length)];
    final next =
        TetrominoLibrary.all[random.nextInt(TetrominoLibrary.all.length)];
    return GameState(
      grid: List.generate(
        AppConstants.boardHeight,
        (_) => List<TetrominoType?>.filled(AppConstants.boardWidth, null),
      ),
      activeType: first.type,
      rotation: 0,
      activePosition: const Position(AppConstants.spawnX, 0),
      nextType: next.type,
      score: 0,
      level: 0,
      linesCleared: 0,
      lastClearCount: 0,
      lastClearedRows: const [],
      clearEventId: 0,
      status: GameStatus.idle,
    );
  }

  static List<List<TetrominoType?>> _cloneGrid(
    List<List<TetrominoType?>> grid,
  ) {
    return grid.map((row) => List<TetrominoType?>.from(row)).toList();
  }
}
