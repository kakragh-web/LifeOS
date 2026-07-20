import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos_ai/features/calendar/domain/calendar_event.dart';
import 'package:lifeos_ai/features/calendar/providers/calendar_providers.dart';
import 'package:lifeos_ai/features/calendar/presentation/screens/calendar_screen.dart';
import '../helpers/asset_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    mockAssets();
  });

  Widget buildApp() => ProviderScope(
        overrides: [
          calendarEventsProvider
              .overrideWith((ref) => Stream.value(<CalendarEvent>[])),
        ],
        child: MediaQuery(
          data: const MediaQueryData(size: Size(800, 1200)),
          child: MaterialApp(
            theme: ThemeData(useMaterial3: true),
            home: const Scaffold(body: CalendarScreen()),
          ),
        ),
      );

  group('CalendarScreen', () {
    testWidgets('shows the app bar title', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      expect(find.text('Calendar'), findsOneWidget);
    });

    testWidgets('renders the weekday header', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      expect(find.text('Mon'), findsOneWidget);
      expect(find.text('Sun'), findsOneWidget);
    });

    testWidgets('shows empty day state for the selected day', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      expect(find.text('No events on this day'), findsOneWidget);
      expect(find.text('Add event'), findsOneWidget);
    });

    testWidgets('has a month navigation chevron', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      expect(
        find.widgetWithIcon(IconButton, Icons.chevron_right_rounded),
        findsOneWidget,
      );
    });
  });
}
