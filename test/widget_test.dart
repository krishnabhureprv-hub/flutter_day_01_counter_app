import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/main.dart'; 

void main() {
  testWidgets('Counter increment and reset test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyCounterApp());

    expect(find.text('0'), findsOneWidget); 
    
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle(); 

    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();

    expect(find.text('0'), findsOneWidget);
  });
}