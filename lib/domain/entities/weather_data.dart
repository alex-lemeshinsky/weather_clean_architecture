import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class WeatherData extends Equatable {
  final double temp;
  final double windSpeed;
  final int windDeg;
  final IconData icon;
  final DateTime dateTime;

  const WeatherData({
    required this.temp,
    required this.windSpeed,
    required this.windDeg,
    required this.icon,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [temp, windSpeed, windDeg, icon, dateTime];
}
