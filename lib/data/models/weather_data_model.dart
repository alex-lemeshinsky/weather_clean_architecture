import 'package:flutter/material.dart';
import 'package:weather_clean_architecture/application/config/const.dart';
import 'package:weather_clean_architecture/domain/entities/weather_data.dart';

class WeatherDataModel {
  final double temp;
  final double windSpeed;
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
      description: json["weather"]["main"],
      icon: json["weather"]["icon"],
      dateTime: json["dt"],
    );
  }

  WeatherData toDomain() {
    return WeatherData(
      temp: temp,
      windSpeed: windSpeed,
      windDeg: windDeg,
      icon: weatherIcons[icon] ?? Icons.question_mark,
      dateTime: DateTime.fromMillisecondsSinceEpoch(dateTime),
    );
  }
}
