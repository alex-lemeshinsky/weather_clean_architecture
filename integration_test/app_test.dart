import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:weather_clean_architecture/main.dart' as app;
import 'package:weather_clean_architecture/presentation/ui/views/home_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Integration test', (WidgetTester tester) async {
    app.main();

    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(HourlyForecastWidget), findsNWidgets(5));
    expect(find.byType(DailyForecastWidget), findsNWidgets(5));

    final Finder fab = find.byTooltip("Reload");
    await tester.tap(fab);

    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(HourlyForecastWidget), findsNWidgets(5));
    expect(find.byType(DailyForecastWidget), findsNWidgets(5));
  });
}
