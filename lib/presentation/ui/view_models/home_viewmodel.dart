import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_clean_architecture/domain/entities/city.dart';
import 'package:weather_clean_architecture/domain/entities/latlng.dart';
import 'package:weather_clean_architecture/domain/entities/weather.dart';
import 'package:weather_clean_architecture/domain/entities/weather_data.dart';
import 'package:weather_clean_architecture/foundation/core/exceptions.dart';
import 'package:weather_clean_architecture/foundation/data/weather_repository_interface.dart';

class HomeViewModel with ChangeNotifier {
  final WeatherRepositoryInterface _repository;

  HomeViewModel(this._repository);

  Weather? _weather;
  String? _errorMessage;

  bool get hasWeather => _weather != null;
  City get city => _weather!.city;
  WeatherData get currentWeather => _weather!.currentWeather;
  List<WeatherData> get hourlyForecast => _weather!.hourlyForecast;
  List<WeatherData> get dailyForecast => _weather!.dailyForecast;
  bool get hasError => _errorMessage != null;
  String? get errorMessage => _errorMessage;

  Future<void> getWeather() async {
    _weather = null;
    _errorMessage = null;
    notifyListeners();

    try {
      final userPosition = await _determineUserPosition();
      _weather = await _repository.getWeather(
        LatLng(lat: userPosition.latitude, lng: userPosition.longitude),
      );
    } on LocationServicesException {
      _errorMessage = "Location services are disabled";
    } on LocationPermissionsException {
      _errorMessage = "Location permissions were not granted";
    } on ServerException {
      _errorMessage =
          "Could not get data from the internet, check your internet connection";
    }
    notifyListeners();
  }

  Future<Position> _determineUserPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServicesException();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationPermissionsException();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationPermissionsException();
    }

    return await Geolocator.getCurrentPosition();
  }
}
