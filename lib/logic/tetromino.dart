import '../models/position.dart';

enum TetrominoType { I, O, T, S, Z, J, L }

class Tetromino {
  final TetrominoType type;
  final List<List<Position>> rotations;

  const Tetromino(this.type, this.rotations);

  List<Position> cells(int rotationIndex) {
    final index = rotationIndex % rotations.length;
    return rotations[index];
  }
}

class TetrominoLibrary {
  static const i = Tetromino(
    TetrominoType.I,
    [
      [Position(0, 1), Position(1, 1), Position(2, 1), Position(3, 1)],
      [Position(2, 0), Position(2, 1), Position(2, 2), Position(2, 3)],
    ],
  );

  static const o = Tetromino(
    TetrominoType.O,
    [
      [Position(1, 1), Position(2, 1), Position(1, 2), Position(2, 2)],
    ],
  );

  static const t = Tetromino(
    TetrominoType.T,
    [
      [Position(1, 1), Position(0, 2), Position(1, 2), Position(2, 2)],
      [Position(1, 1), Position(1, 2), Position(2, 2), Position(1, 3)],
      [Position(0, 2), Position(1, 2), Position(2, 2), Position(1, 3)],
      [Position(1, 1), Position(0, 2), Position(1, 2), Position(1, 3)],
    ],
  );

  static const s = Tetromino(
    TetrominoType.S,
    [
      [Position(1, 1), Position(2, 1), Position(0, 2), Position(1, 2)],
      [Position(1, 1), Position(1, 2), Position(2, 2), Position(2, 3)],
    ],
  );

  static const z = Tetromino(
    TetrominoType.Z,
    [
      [Position(0, 1), Position(1, 1), Position(1, 2), Position(2, 2)],
      [Position(2, 1), Position(1, 2), Position(2, 2), Position(1, 3)],
    ],
  );

  static const j = Tetromino(
    TetrominoType.J,
    [
      [Position(0, 1), Position(0, 2), Position(1, 2), Position(2, 2)],
      [Position(1, 1), Position(2, 1), Position(1, 2), Position(1, 3)],
      [Position(0, 2), Position(1, 2), Position(2, 2), Position(2, 3)],
      [Position(1, 1), Position(1, 2), Position(0, 3), Position(1, 3)],
    ],
  );

  static const l = Tetromino(
    TetrominoType.L,
    [
      [Position(2, 1), Position(0, 2), Position(1, 2), Position(2, 2)],
      [Position(1, 1), Position(1, 2), Position(1, 3), Position(2, 3)],
      [Position(0, 2), Position(1, 2), Position(2, 2), Position(0, 3)],
      [Position(0, 1), Position(1, 1), Position(1, 2), Position(1, 3)],
    ],
  );

  static const all = [i, o, t, s, z, j, l];
}
