import 'package:flutter/material.dart';
import 'package:weather_clean_architecture/application/config/const.dart';
import 'package:weather_clean_architecture/domain/entities/weather_data.dart';

class WeatherDataModel {
  final num temp;
  final num windSpeed;
  final int windDeg;
  final String description;
  final String icon;
  final int dateTime;

  WeatherDataModel({
    required this.temp,
    required this.windSpeed,
    required this.windDeg,
    required this.description,
    required this.icon,
    required this.dateTime,
  });

  factory WeatherDataModel.fromJson(Map<String, dynamic> json) {
    return WeatherDataModel(
      temp: json["temp"],
      windSpeed: json["wind_speed"],
      windDeg: json["wind_deg"],
      description: json["weather"][0]["main"],
      icon: json["weather"][0]["icon"],
      dateTime: json["dt"],
    );
  }

  factory WeatherDataModel.fromDailyForecastJson(Map<String, dynamic> json) {
    return WeatherDataModel(
      temp: json["temp"]["max"],
      windSpeed: json["wind_speed"],
      windDeg: json["wind_deg"],
      description: json["weather"][0]["main"],
      icon: json["weather"][0]["icon"],
      dateTime: json["dt"],
    );
  }

  WeatherData toDomain() {
    return WeatherData(
      temp: temp.toDouble(),
      windSpeed: windSpeed.toDouble(),
      windDeg: windDeg,
      description: description,
      icon: weatherIcons[icon] ?? Icons.question_mark,
      dateTime: DateTime.fromMillisecondsSinceEpoch(dateTime * 1000),
    );
  }
}
