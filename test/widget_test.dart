import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos_ai/main.dart' as app;

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: app.LifeOsApp(),
      ),
    );
    expect(find.byType(app.LifeOsApp), findsOneWidget);
  });
}
