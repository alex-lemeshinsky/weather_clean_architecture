import 'package:flutter/material.dart';

class WeatherData {
  final double temp;
  final double windSpeed;
  final double windDeg;
  final IconData icon;
  final DateTime dateTime;

  WeatherData({
    required this.temp,
    required this.windSpeed,
    required this.windDeg,
    required this.icon,
    required this.dateTime,
  });
}
