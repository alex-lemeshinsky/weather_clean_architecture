import 'package:equatable/equatable.dart';
import 'package:weather_clean_architecture/domain/entities/city.dart';
import 'package:weather_clean_architecture/domain/entities/weather_data.dart';

class Weather extends Equatable {
  final City city;
  final WeatherData currentWeather;
  final List<WeatherData> hourlyForecast;
  final List<WeatherData> dailyForecast;

  const Weather({
    required this.city,
    required this.currentWeather,
    required this.hourlyForecast,
    required this.dailyForecast,
  });

  @override
  List<Object?> get props => [
        city,
        currentWeather,
        hourlyForecast,
        dailyForecast,
      ];
}
