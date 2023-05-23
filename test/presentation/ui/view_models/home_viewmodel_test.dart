import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_clean_architecture/application/config/const.dart';
import 'package:weather_clean_architecture/data/repository/weather_repository_impl.dart';
import 'package:weather_clean_architecture/domain/entities/latlng.dart';
import 'package:weather_clean_architecture/foundation/core/exceptions.dart';
import 'package:weather_clean_architecture/foundation/data/weather_repository_interface.dart';
import 'package:weather_clean_architecture/presentation/ui/view_models/home_viewmodel.dart';

import '../../../fixtures/mock_entities.dart';

class MockWeatherRepository extends Mock implements WeatherRepositoryImpl {}

class MockGeolocator extends Mock implements GeolocatorPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(const LatLng(lat: 0.0, lng: 0.0));
  });

  group('HomeViewModel', () {
    late HomeViewModel viewModel;
    late WeatherRepositoryInterface mockRepository;
    late GeolocatorPlatform mockGeolocator;

    setUp(() {
      mockRepository = MockWeatherRepository();
      mockGeolocator = MockGeolocator();
      viewModel = HomeViewModel(mockRepository, mockGeolocator);
    });

    void setupMockGeolocator() {
      when(() => mockGeolocator.isLocationServiceEnabled())
          .thenAnswer((_) async => true);
      when(() => mockGeolocator.checkPermission())
          .thenAnswer((_) async => LocationPermission.whileInUse);
      when(() => mockGeolocator.getCurrentPosition())
          .thenAnswer((_) async => mockPosition);
    }

    test('initial state', () {
      // Assert
      expect(viewModel.hasWeather, isFalse);
      expect(viewModel.hasError, isFalse);
      expect(viewModel.errorMessage, isNull);
    });

    test('getWeather success', () async {
      // Arrange
      setupMockGeolocator();
      when(() => mockRepository.getWeather(any()))
          .thenAnswer((_) async => mockWeather);

      // Act
      await viewModel.getWeather();

      // Assert
      expect(viewModel.hasWeather, isTrue);
      expect(viewModel.city, equals(mockWeather.city));
      expect(viewModel.currentWeather, equals(mockWeather.currentWeather));
      expect(viewModel.hourlyForecast, equals(mockWeather.hourlyForecast));
      expect(viewModel.dailyForecast, equals(mockWeather.dailyForecast));
      expect(viewModel.hasError, isFalse);
      expect(viewModel.errorMessage, isNull);
    });

    test('getWeather LocationServicesException', () async {
      // Arrange
      when(() => mockGeolocator.isLocationServiceEnabled())
          .thenAnswer((_) async => false);

      // Act
      await viewModel.getWeather();

      // Assert
      expect(viewModel.hasWeather, isFalse);
      expect(viewModel.hasError, isTrue);
      expect(viewModel.errorMessage, equals(locationServicesExceptionMessage));
    });

    test('getWeather LocationPermissionsException', () async {
      // Arrange
      when(() => mockGeolocator.isLocationServiceEnabled())
          .thenAnswer((_) async => true);
      when(() => mockGeolocator.checkPermission())
          .thenAnswer((_) async => LocationPermission.denied);
      when(() => mockGeolocator.requestPermission())
          .thenAnswer((_) async => LocationPermission.denied);

      // Act
      await viewModel.getWeather();

      // Assert
      expect(viewModel.hasWeather, isFalse);
      expect(viewModel.hasError, isTrue);
      expect(
        viewModel.errorMessage,
        equals(locationPermissionsExceptionMessage),
      );
    });

    test('getWeather ServerException', () async {
      // Arrange
      setupMockGeolocator();
      when(() => mockRepository.getWeather(any())).thenThrow(ServerException());

      // Act
      await viewModel.getWeather();

      // Assert
      expect(viewModel.hasWeather, isFalse);
      expect(viewModel.hasError, isTrue);
      expect(viewModel.errorMessage, equals(serverExceptionMessage));
    });
  });
}
