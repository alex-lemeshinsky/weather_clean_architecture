import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_clean_architecture/domain/entities/city.dart';
import 'package:weather_clean_architecture/domain/entities/latlng.dart';
import 'package:weather_clean_architecture/domain/entities/weather.dart';
import 'package:weather_clean_architecture/domain/entities/weather_data.dart';
import 'package:weather_clean_architecture/domain/use_cases/get_weather.dart';
import 'package:weather_clean_architecture/foundation/data/weather_repository_interface.dart';
import 'package:weather_icons/weather_icons.dart';

class MockWeatherRepository extends Mock
    implements WeatherRepositoryInterface {}

void main() {
  group(
    'GetWeather usecase',
    () {
      late GetWeather useCase;
      late WeatherRepositoryInterface mockRepository;

      setUp(() {
        mockRepository = MockWeatherRepository();
        useCase = GetWeather(mockRepository);
      });

      const testLatLng = LatLng(lat: 37.7749, lng: -122.4194);
      const testParams = CoordinateParams(coords: testLatLng);

      const mockCity = City(
        name: 'San Francisco',
        coords: LatLng(lat: 37.7749, lng: -122.4194),
      );
      final mockWeatherData = WeatherData(
        temp: 1,
        windSpeed: 1,
        windDeg: 1,
        description: "description",
        icon: WeatherIcons.day_sunny,
        dateTime: DateTime.now(),
      );
      final mockWeather = Weather(
        city: mockCity,
        currentWeather: mockWeatherData,
        hourlyForecast: [mockWeatherData],
        dailyForecast: [mockWeatherData],
      );

      test(
        'calls WeatherRepository.getWeather with the correct parameters',
        () async {
          // Arrange
          when(() => mockRepository.getWeather(testLatLng))
              .thenAnswer((_) => Future.value(mockWeather));

          // Act
          final result = await useCase(testParams);

          // Assert
          expect(result, equals(mockWeather));
          verify(() => mockRepository.getWeather(testLatLng));
          verifyNoMoreInteractions(mockRepository);
        },
      );
    },
  );
}
