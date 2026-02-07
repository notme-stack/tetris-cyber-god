enum GameDifficulty { safe, moderate, high }

class GameDifficultyConfig {
  final GameDifficulty difficulty;
  final double fallSpeedFactor;

  const GameDifficultyConfig({
    required this.difficulty,
    required this.fallSpeedFactor,
  });

  static const safe = GameDifficultyConfig(
    difficulty: GameDifficulty.safe,
    fallSpeedFactor: 1.0,
  );

  static const moderate = GameDifficultyConfig(
    difficulty: GameDifficulty.moderate,
    fallSpeedFactor: 0.4,
  );

  static const high = GameDifficultyConfig(
    difficulty: GameDifficulty.high,
    fallSpeedFactor: 0.2,
  );

  static const all = [safe, moderate, high];

  static GameDifficultyConfig fromDifficulty(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.safe:
        return safe;
      case GameDifficulty.moderate:
        return moderate;
      case GameDifficulty.high:
        return high;
    }
  }
}
