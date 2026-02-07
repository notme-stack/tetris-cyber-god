import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _keyLastScore = 'last_score';
  static const _keySystemId = 'system_id';
  static const _keyDifficulty = 'difficulty';

  Future<int> getLastScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyLastScore) ?? 0;
  }

  Future<void> setLastScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLastScore, score);
  }

  Future<String> getSystemId() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_keySystemId);
    if (existing != null && existing.isNotEmpty) return existing;

    final rand = Random();
    final number = 1000 + rand.nextInt(9000);
    final letter = String.fromCharCode(65 + rand.nextInt(26));
    final id = '#$number-$letter';
    await prefs.setString(_keySystemId, id);
    return id;
  }

  Future<String> getDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDifficulty) ?? 'safe';
  }

  Future<void> setDifficulty(String difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDifficulty, difficulty);
  }
}
