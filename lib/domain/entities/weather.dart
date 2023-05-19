import 'package:weather_clean_architecture/domain/entities/city.dart';
import 'package:weather_clean_architecture/domain/entities/weather_data.dart';

class Weather {
  final City city;
  final WeatherData currentWeather;
  final List<WeatherData> hourlyForecast;
  final List<WeatherData> dailyForecast;

  Weather({
    required this.city,
    required this.currentWeather,
    required this.hourlyForecast,
    required this.dailyForecast,
  });
}
