import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/main.dart';

void main() {
  testWidgets('Goal Setting and Counter Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyCounterApp());

    // Initial value check
    expect(find.text('0'), findsOneWidget);

    // Settings icon check
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

    // Increment 
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);

    // Reset
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsOneWidget);
  });
}