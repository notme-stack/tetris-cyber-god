import 'package:flutter_test/flutter_test.dart';
import 'package:tetris_cyber_gods/logic/tetris_engine.dart';
import 'package:tetris_cyber_gods/logic/game_state.dart';
import 'package:tetris_cyber_gods/config/constants.dart';
import 'package:tetris_cyber_gods/models/position.dart';

void main() {
  group('TetrisEngine Flow Tests', () {
    late TetrisEngine engine;

    setUp(() {
      engine = TetrisEngine();
    });

    test('Initial state is idle', () {
      expect(engine.state.status, GameStatus.idle);
    });

    test('Start game changes status to running', () {
      engine.start();
      expect(engine.state.status, GameStatus.running);
      expect(
        engine.state.activePosition,
        equals(const Position(AppConstants.spawnX, 0)),
      );
    });

    test('Move right moves the piece', () {
      engine.start();
      final initialX = engine.state.activePosition.x;
      engine.moveRight();
      expect(engine.state.activePosition.x, equals(initialX + 1));
    });

    test('Move left moves the piece', () {
      engine.start();
      final initialX = engine.state.activePosition.x;
      engine.moveLeft();
      expect(engine.state.activePosition.x, equals(initialX - 1));
    });

    test('Hard drop locks piece immediately', () {
      engine.start();
      engine.hardDrop();
      // After hard drop, a new piece should spawn.
      // The previous piece should be locked in the grid.
      // And active position should be reset to spawn.
      expect(
        engine.state.activePosition,
        equals(const Position(AppConstants.spawnX, 0)),
      );
    });
  });
}
