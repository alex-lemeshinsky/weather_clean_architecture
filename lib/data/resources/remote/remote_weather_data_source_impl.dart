import 'dart:convert';

import 'package:weather_clean_architecture/application/config/const.dart';
import 'package:weather_clean_architecture/data/models/city_model.dart';
import 'package:weather_clean_architecture/data/models/weather_data_model.dart';
import 'package:weather_clean_architecture/data/models/weather_model.dart';
import 'package:weather_clean_architecture/foundation/core/exceptions.dart';
import 'package:weather_clean_architecture/foundation/data/weather_data_source_interface.dart';
import 'package:http/http.dart' as http;

class RemoteWeatherDataSourceImpl implements RemoteWeatherDataSourceInterface {
  static const String _baseUrl = "https://api.openweathermap.org/";

  final http.Client client;

  RemoteWeatherDataSourceImpl(this.client);

  @override
  Future<CityModel> getCity(double lat, double lon) async {
    final url = Uri.parse(
      "${_baseUrl}geo/1.0/reverse?lat=$lat&lon=$lon&appid=$apiKey",
    );
    final response = await client.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }

    final json = jsonDecode(response.body)[0];

    return CityModel.fromJson(json);
  }

  @override
  Future<WeatherModel> getWeatherData(double lat, double lon) async {
    final url = Uri.parse(
      "${_baseUrl}data/3.0/onecall?units=metric&lat=$lat&lon=$lon&appid=$apiKey",
    );
    final response = await client.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }

    final jsonData = jsonDecode(response.body);
    final currentWeatherJson = jsonData["current"];
    final hourlyForecastJson = (jsonData["hourly"] as List).sublist(1, 5);
    final dailyForecastJson = (jsonData["daily"] as List).sublist(1, 5);

    return WeatherModel(
      currentWeather: WeatherDataModel.fromJson(currentWeatherJson),
      hourlyForecast:
          hourlyForecastJson.map((e) => WeatherDataModel.fromJson(e)).toList(),
      dailyForecast: dailyForecastJson
          .map((e) => WeatherDataModel.fromDailyForecastJson(e))
          .toList(),
    );
  }
}
