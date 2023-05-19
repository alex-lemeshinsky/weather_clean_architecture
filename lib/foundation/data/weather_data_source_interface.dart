import 'package:weather_clean_architecture/data/models/city_model.dart';
import 'package:weather_clean_architecture/data/models/weather_model.dart';

abstract class RemoteWeatherDataSourceInterface {
  Future<WeatherModel> getWeatherData(double lat, double lon);
  Future<CityModel> getCity(double lat, double lon);
}
