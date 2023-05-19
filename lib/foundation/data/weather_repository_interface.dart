import 'package:weather_clean_architecture/domain/entities/latlng.dart';
import 'package:weather_clean_architecture/domain/entities/weather.dart';

abstract class WeatherRepositoryInterface {
  Future<Weather> getWeather(LatLng coords);
}
