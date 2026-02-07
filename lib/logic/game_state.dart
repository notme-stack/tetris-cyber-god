import '../models/position.dart';
import 'tetromino.dart';

enum GameStatus { idle, running, paused, over }

class GameState {
  final List<List<TetrominoType?>> grid;
  final TetrominoType activeType;
  final int rotation;
  final Position activePosition;
  final Position? ghostPosition;
  final TetrominoType nextType;
  final int score;
  final int level;
  final int linesCleared;
  final int lastClearCount;
  final List<int> lastClearedRows;
  final int clearEventId;
  final GameStatus status;

  const GameState({
    required this.grid,
    required this.activeType,
    required this.rotation,
    required this.activePosition,
    this.ghostPosition,
    required this.nextType,
    required this.score,
    required this.level,
    required this.linesCleared,
    required this.lastClearCount,
    required this.lastClearedRows,
    required this.clearEventId,
    required this.status,
  });

  GameState copyWith({
    List<List<TetrominoType?>>? grid,
    TetrominoType? activeType,
    int? rotation,
    Position? activePosition,
    Position? ghostPosition,
    TetrominoType? nextType,
    int? score,
    int? level,
    int? linesCleared,
    int? lastClearCount,
    List<int>? lastClearedRows,
    int? clearEventId,
    GameStatus? status,
  }) {
    return GameState(
      grid: grid ?? this.grid,
      activeType: activeType ?? this.activeType,
      rotation: rotation ?? this.rotation,
      activePosition: activePosition ?? this.activePosition,
      ghostPosition: ghostPosition ?? this.ghostPosition,
      nextType: nextType ?? this.nextType,
      score: score ?? this.score,
      level: level ?? this.level,
      linesCleared: linesCleared ?? this.linesCleared,
      lastClearCount: lastClearCount ?? this.lastClearCount,
      lastClearedRows: lastClearedRows ?? this.lastClearedRows,
      clearEventId: clearEventId ?? this.clearEventId,
      status: status ?? this.status,
    );
  }
}
