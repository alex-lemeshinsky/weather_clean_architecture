import 'package:flutter_test/flutter_test.dart';
import 'package:weather_clean_architecture/data/models/weather_model.dart';
import 'package:weather_clean_architecture/data/models/city_model.dart';
import 'package:weather_clean_architecture/data/models/weather_data_model.dart';
import 'package:weather_icons/weather_icons.dart';

void main() {
  group(
    'WeatherModel',
    () {
      final cityModel = CityModel(name: 'City', lat: 0.0, lon: 0.0);
      final currentWeatherDataModel = WeatherDataModel(
        temp: 25.0,
        windSpeed: 10.0,
        windDeg: 180,
        description: 'Sunny',
        icon: '01d',
        dateTime: 1621705400,
      );
      final hourlyForecastDataModel = [
        WeatherDataModel(
          temp: 22.0,
          windSpeed: 12.0,
          windDeg: 270,
          description: 'Cloudy',
          icon: '04d',
          dateTime: 1621805400,
        ),
      ];
      final dailyForecastDataModel = [
        WeatherDataModel(
          temp: 20.0,
          windSpeed: 15.0,
          windDeg: 90,
          description: 'Rainy',
          icon: '10d',
          dateTime: 1621905400,
        ),
      ];

      final weatherModel = WeatherModel(
        currentWeather: currentWeatherDataModel,
        hourlyForecast: hourlyForecastDataModel,
        dailyForecast: dailyForecastDataModel,
      );

      test(
        'toDomain() converts to Weather correctly',
        () {
          final weather = weatherModel.toDomain(cityModel);

          expect(weather.city.name, 'City');
          expect(weather.currentWeather.temp, 25.0);
          expect(weather.currentWeather.windSpeed, 10.0);
          expect(weather.currentWeather.windDeg, 180);
          expect(weather.currentWeather.description, 'Sunny');
          expect(weather.currentWeather.icon, WeatherIcons.day_sunny);
          expect(
            weather.currentWeather.dateTime,
            DateTime.fromMillisecondsSinceEpoch(1621705400000),
          );

          expect(weather.hourlyForecast.length, 1);
          expect(weather.hourlyForecast[0].temp, 22.0);
          expect(weather.hourlyForecast[0].windSpeed, 12.0);
          expect(weather.hourlyForecast[0].windDeg, 270);
          expect(weather.hourlyForecast[0].description, 'Cloudy');
          expect(weather.hourlyForecast[0].icon, WeatherIcons.cloudy);
          expect(
            weather.hourlyForecast[0].dateTime,
            DateTime.fromMillisecondsSinceEpoch(1621805400000),
          );

          expect(weather.dailyForecast.length, 1);
          expect(weather.dailyForecast[0].temp, 20.0);
          expect(weather.dailyForecast[0].windSpeed, 15.0);
          expect(weather.dailyForecast[0].windDeg, 90);
          expect(weather.dailyForecast[0].description, 'Rainy');
          expect(weather.dailyForecast[0].icon, WeatherIcons.day_rain);
          expect(
            weather.dailyForecast[0].dateTime,
            DateTime.fromMillisecondsSinceEpoch(1621905400000),
          );
        },
      );
    },
  );
}
