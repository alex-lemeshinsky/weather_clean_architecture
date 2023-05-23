import 'package:flutter_test/flutter_test.dart';
import 'package:weather_clean_architecture/data/models/weather_data_model.dart';
import 'package:weather_icons/weather_icons.dart';

void main() {
  group(
    'WeatherDataModel',
    () {
      test(
        'fromJson() creates WeatherDataModel instance correctly',
        () {
          // Create a sample JSON data for WeatherDataModel
          final jsonData = {
            "temp": 25.0,
            "wind_speed": 10.0,
            "wind_deg": 180,
            "weather": [
              {"main": "Sunny", "icon": "01d"}
            ],
            "dt": 1621705400
          };

          // Call the fromJson() method
          final weatherDataModel = WeatherDataModel.fromJson(jsonData);

          // Assert the created WeatherDataModel instance
          expect(weatherDataModel.temp, 25.0);
          expect(weatherDataModel.windSpeed, 10.0);
          expect(weatherDataModel.windDeg, 180);
          expect(weatherDataModel.description, 'Sunny');
          expect(weatherDataModel.icon, '01d');
          expect(weatherDataModel.dateTime, 1621705400);
        },
      );

      test(
        'fromDailyForecastJson() creates WeatherDataModel instance correctly',
        () {
          // Create a sample JSON data for daily forecast WeatherDataModel
          final jsonData = {
            "temp": {"max": 20.0},
            "wind_speed": 12.0,
            "wind_deg": 270,
            "weather": [
              {"main": "Cloudy", "icon": "04d"}
            ],
            "dt": 1621805400
          };

          // Call the fromDailyForecastJson() method
          final weatherDataModel =
              WeatherDataModel.fromDailyForecastJson(jsonData);

          // Assert the created WeatherDataModel instance
          expect(weatherDataModel.temp, 20.0);
          expect(weatherDataModel.windSpeed, 12.0);
          expect(weatherDataModel.windDeg, 270);
          expect(weatherDataModel.description, 'Cloudy');
          expect(weatherDataModel.icon, '04d');
          expect(weatherDataModel.dateTime, 1621805400);
        },
      );

      test(
        'toDomain() converts to WeatherData correctly',
        () {
          // Create a sample WeatherDataModel instance
          final weatherDataModel = WeatherDataModel(
            temp: 25.0,
            windSpeed: 10.0,
            windDeg: 180,
            description: 'Sunny',
            icon: '01d',
            dateTime: 1621705400,
          );

          // Call the toDomain() method
          final weatherData = weatherDataModel.toDomain();

          // Assert the converted WeatherData object
          expect(weatherData.temp, 25.0);
          expect(weatherData.windSpeed, 10.0);
          expect(weatherData.windDeg, 180);
          expect(weatherData.description, 'Sunny');
          expect(weatherData.icon, WeatherIcons.day_sunny);
          expect(
            weatherData.dateTime,
            DateTime.fromMillisecondsSinceEpoch(1621705400000),
          );
        },
      );
    },
  );
}
