import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:weather_clean_architecture/data/resources/remote/remote_weather_data_source_impl.dart';
import 'package:weather_clean_architecture/foundation/core/exceptions.dart';

import '../../fixtures/fixture_reader.dart';

class MockRequest extends Mock implements http.Request {}

class MockClient extends Mock implements http.Client {}

void main() {
  final mockClient = MockClient();
  final remoteWeatherDataSource = RemoteWeatherDataSourceImpl(mockClient);

  setUpAll(() {
    registerFallbackValue(Uri.parse(""));
  });

  group('RemoteWeatherDataSourceImpl', () {
    test(
      'getCity() returns CityModel correctly',
      () async {
        when(
          () => mockClient.get(
            any(),
            headers: {"Content-Type": "application/json"},
          ),
        ).thenAnswer(
          (_) async =>
              http.Response(fixture("reverse_geocoding_response.json"), 200),
        );

        final cityModel =
            await remoteWeatherDataSource.getCity(37.422065, -122.08409);

        expect(cityModel.name, 'Mountain View');
        expect(cityModel.lat, 37.3893889);
        expect(cityModel.lon, -122.0832101);
      },
    );

    test(
      'getWeatherData() returns WeatherModel correctly',
      () async {
        when(
          () => mockClient.get(
            any(),
            headers: {"Content-Type": "application/json"},
          ),
        ).thenAnswer(
          (_) async => http.Response(fixture("onecall_api_response.json"), 200),
        );

        final weatherModel = await remoteWeatherDataSource.getWeatherData(
          37.3893889,
          -122.0832101,
        );

        expect(weatherModel.currentWeather.temp, 12.8);
        expect(weatherModel.currentWeather.windSpeed, 1.54);
        expect(weatherModel.currentWeather.windDeg, 50);
        expect(weatherModel.currentWeather.description, 'Clouds');
        expect(weatherModel.currentWeather.icon, '04n');
        expect(weatherModel.currentWeather.dateTime, 1684748045);

        // Assertions for hourly forecast data
        expect(weatherModel.hourlyForecast.length, 5);

        expect(weatherModel.hourlyForecast[0].temp, 12.8);
        expect(weatherModel.hourlyForecast[0].windSpeed, 0.98);
        expect(weatherModel.hourlyForecast[0].windDeg, 227);
        expect(weatherModel.hourlyForecast[0].description, "Clouds");
        expect(weatherModel.hourlyForecast[0].icon, '04n');
        expect(weatherModel.hourlyForecast[0].dateTime, 1684749600);

        // Assertions for daily forecast data
        expect(weatherModel.dailyForecast.length, 5);

        expect(weatherModel.dailyForecast[0].temp, 22.56);
        expect(weatherModel.dailyForecast[0].windSpeed, 3.3);
        expect(weatherModel.dailyForecast[0].windDeg, 228);
        expect(weatherModel.dailyForecast[0].description, "Clear");
        expect(weatherModel.dailyForecast[0].icon, '01d');
        expect(weatherModel.dailyForecast[0].dateTime, 1684872000);
      },
    );

    test('getCity() throws ServerException for non-200 response', () async {
      when(
        () => mockClient
            .get(any(), headers: {"Content-Type": "application/json"}),
      ).thenAnswer((_) async => http.Response("Something went wrong", 503));

      expect(
        () => remoteWeatherDataSource.getCity(37.3893889, -122.0832101),
        throwsA(isA<ServerException>()),
      );
    });

    test('getWeatherData() throws ServerException for non-200 response',
        () async {
      when(
        () => mockClient
            .get(any(), headers: {"Content-Type": "application/json"}),
      ).thenAnswer((_) async => http.Response("Something went wrong", 503));

      expect(
        () => remoteWeatherDataSource.getWeatherData(37.3893889, -122.0832101),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
