import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos_ai/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LifeOsApp());
    expect(find.byType(LifeOsApp), findsOneWidget);
  });
}
