import 'package:weather_clean_architecture/domain/entities/weather.dart';

import 'city_model.dart';
import 'weather_data_model.dart';

class WeatherModel {
  final WeatherDataModel currentWeather;
  final List<WeatherDataModel> hourlyForecast;
  final List<WeatherDataModel> dailyForecast;

  WeatherModel({
    required this.currentWeather,
    required this.hourlyForecast,
    required this.dailyForecast,
  });

  Weather toDomain(CityModel cityModel) {
    return Weather(
      city: cityModel.toDomain(),
      currentWeather: currentWeather.toDomain(),
      hourlyForecast: hourlyForecast.map((e) => e.toDomain()).toList(),
      dailyForecast: dailyForecast.map((e) => e.toDomain()).toList(),
    );
  }
}
