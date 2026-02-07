import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'screens/arena/arena_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/lobby/lobby_screen.dart';
import 'screens/result/result_screen.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  runApp(const TetrisCyberGodsApp());
}

class TetrisCyberGodsApp extends StatelessWidget {
  const TetrisCyberGodsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tetris_Cyber_Gods',
      theme: AppTheme.buildTheme(),
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/lobby': (_) => const LobbyScreen(),
        '/arena': (_) => const ArenaScreen(),
        '/result': (_) =>
            const ResultScreen(score: 0, duration: '00:00.00', peakLevel: 1),
      },
      initialRoute: '/',
    );
  }
}
