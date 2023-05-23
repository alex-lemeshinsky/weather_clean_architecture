import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_clean_architecture/data/models/city_model.dart';
import 'package:weather_clean_architecture/data/models/weather_data_model.dart';
import 'package:weather_clean_architecture/data/models/weather_model.dart';
import 'package:weather_clean_architecture/data/repository/weather_repository_impl.dart';
import 'package:weather_clean_architecture/domain/entities/latlng.dart';
import 'package:weather_clean_architecture/domain/entities/weather.dart';
import 'package:weather_clean_architecture/foundation/core/exceptions.dart';
import 'package:weather_clean_architecture/foundation/data/weather_data_source_interface.dart';

class MockRemoteWeatherDataSource extends Mock
    implements RemoteWeatherDataSourceInterface {}

void main() {
  group('WeatherRepositoryImpl', () {
    late WeatherRepositoryImpl repository;
    late RemoteWeatherDataSourceInterface mockRemoteDataSource;

    setUp(() {
      mockRemoteDataSource = MockRemoteWeatherDataSource();
      repository =
          WeatherRepositoryImpl(remoteDataSource: mockRemoteDataSource);
    });

    group('getWeather', () {
      const testLatLng = LatLng(lat: 37.7749, lng: -122.4194);

      test('returns a Weather object when remote data source succeeds',
          () async {
        // Arrange
        final mockCityModel = CityModel(
          name: 'San Francisco',
          lat: 37.7749,
          lon: -122.4194,
        );
        final mockWeatherDataModel = WeatherDataModel(
          temp: 1,
          windSpeed: 1,
          windDeg: 1,
          description: "description",
          icon: "01d",
          dateTime: 1684748045,
        );
        final mockWeatherModel = WeatherModel(
          currentWeather: mockWeatherDataModel,
          hourlyForecast: [mockWeatherDataModel],
          dailyForecast: [mockWeatherDataModel],
        );
        final Weather expectedWeather =
            mockWeatherModel.toDomain(mockCityModel);

        when(() => mockRemoteDataSource.getCity(testLatLng.lat, testLatLng.lng))
            .thenAnswer((_) => Future.value(mockCityModel));
        when(() => mockRemoteDataSource.getWeatherData(
                testLatLng.lat, testLatLng.lng))
            .thenAnswer((_) => Future.value(mockWeatherModel));

        // Act
        final result = await repository.getWeather(testLatLng);

        // Assert
        expect(result, equals(expectedWeather));
        verify(
            () => mockRemoteDataSource.getCity(testLatLng.lat, testLatLng.lng));
        verify(() => mockRemoteDataSource.getWeatherData(
            testLatLng.lat, testLatLng.lng));
      });

      test('throws a ServerException when remote data source throws', () async {
        // Arrange
        final serverException = ServerException();

        when(() => mockRemoteDataSource.getCity(testLatLng.lat, testLatLng.lng))
            .thenThrow(serverException);

        // Act and Assert
        expect(
            () => repository.getWeather(testLatLng), throwsA(serverException));
        verify(
            () => mockRemoteDataSource.getCity(testLatLng.lat, testLatLng.lng));
        verifyNever(() => mockRemoteDataSource.getWeatherData(
            testLatLng.lat, testLatLng.lng));
      });
    });
  });
}
