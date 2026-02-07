import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tetris_cyber_gods/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TetrisCyberGodsApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
