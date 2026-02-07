import 'package:flutter/services.dart';

class HapticsService {
  Future<void> lightImpact() => HapticFeedback.lightImpact();
  Future<void> mediumImpact() => HapticFeedback.mediumImpact();
  Future<void> heavyImpact() => HapticFeedback.heavyImpact();
}
