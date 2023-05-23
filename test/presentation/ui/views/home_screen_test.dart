import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:weather_clean_architecture/presentation/ui/view_models/home_viewmodel.dart';
import 'package:weather_clean_architecture/presentation/ui/views/home_screen.dart';
import 'package:weather_icons/weather_icons.dart';

import '../../../fixtures/mock_entities.dart';

class MockHomeViewModel extends Mock implements HomeViewModel {
  @override
  Future<void> getWeather() async {}
}

void main() {
  group('HomeScreen', () {
    late MockHomeViewModel mockViewModel;
    late Widget testWidget;

    setUp(() {
      mockViewModel = MockHomeViewModel();

      testWidget = ChangeNotifierProvider<HomeViewModel>(
        create: (_) => mockViewModel,
        builder: (context, child) => const MaterialApp(
          home: HomeScreen(),
        ),
      );
    });

    testWidgets('displays loading indicator when weather data is loading',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockViewModel.hasWeather).thenReturn(false);
      when(() => mockViewModel.hasError).thenReturn(false);

      // Act
      await tester.pumpWidget(testWidget);

      // // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error message when weather data loading failed',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockViewModel.hasWeather).thenReturn(false);
      when(() => mockViewModel.hasError).thenReturn(true);
      when(() => mockViewModel.errorMessage).thenReturn('Error Message');

      // Act
      await tester.pumpWidget(testWidget);

      // Assert
      expect(find.text('Error Message'), findsOneWidget);
    });

    testWidgets('displays weather data when available',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockViewModel.hasWeather).thenReturn(true);
      when(() => mockViewModel.city).thenReturn(mockWeather.city);
      when(() => mockViewModel.currentWeather)
          .thenReturn(mockWeather.currentWeather);
      when(() => mockViewModel.hourlyForecast)
          .thenReturn(mockWeather.hourlyForecast);
      when(() => mockViewModel.dailyForecast)
          .thenReturn(mockWeather.dailyForecast);

      // Act
      await tester.pumpWidget(testWidget);

      // Assert
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text("San Francisco"), findsOneWidget);
      expect(find.text("Cloudy"), findsOneWidget);
      expect(find.text('25°'), findsNWidgets(11));
      expect(find.byIcon(WeatherIcons.day_sunny), findsNWidgets(11));
      expect(find.text('3.5 m/s'), findsOneWidget);
      expect(find.byType(HourlyForecastWidget), findsNWidgets(5));
      expect(find.byType(DailyForecastWidget), findsNWidgets(5));
    });
  });
}
