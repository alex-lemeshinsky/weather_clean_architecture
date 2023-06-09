import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_clean_architecture/application/config/const.dart';
import 'package:weather_clean_architecture/domain/entities/city.dart';
import 'package:weather_clean_architecture/domain/entities/latlng.dart';
import 'package:weather_clean_architecture/domain/entities/weather.dart';
import 'package:weather_clean_architecture/domain/entities/weather_data.dart';
import 'package:weather_clean_architecture/foundation/core/exceptions.dart';
import 'package:weather_clean_architecture/foundation/data/weather_repository_interface.dart';

class HomeViewModel with ChangeNotifier {
  final WeatherRepositoryInterface _repository;
  final GeolocatorPlatform _geolocatorPlatform;

  HomeViewModel(this._repository, this._geolocatorPlatform);

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
      _errorMessage = locationServicesExceptionMessage;
    } on LocationPermissionsException {
      _errorMessage = locationPermissionsExceptionMessage;
    } on ServerException {
      _errorMessage = serverExceptionMessage;
    }
    notifyListeners();
  }

  Future<Position> _determineUserPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServicesException();
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationPermissionsException();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationPermissionsException();
    }

    return await _geolocatorPlatform.getCurrentPosition();
  }
}
