import 'package:weather_clean_architecture/domain/entities/latlng.dart';
import 'package:weather_clean_architecture/domain/entities/weather.dart';
import 'package:weather_clean_architecture/foundation/core/exceptions.dart';
import 'package:weather_clean_architecture/foundation/data/weather_data_source_interface.dart';
import 'package:weather_clean_architecture/foundation/data/weather_repository_interface.dart';

class WeatherRepositoryImpl implements WeatherRepositoryInterface {
  final RemoteWeatherDataSourceInterface remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Weather> getWeather(LatLng coords) async {
    try {
      final city = await remoteDataSource.getCity(coords.lat, coords.lng);
      final weather =
          await remoteDataSource.getWeatherData(coords.lat, coords.lng);

      return Weather(
        city: city.toDomain(),
        currentWeather: weather.currentWeather.toDomain(),
        hourlyForecast:
            weather.hourlyForecast.map((e) => e.toDomain()).toList(),
        dailyForecast: weather.dailyForecast.map((e) => e.toDomain()).toList(),
      );
    } on ServerException {
      rethrow;
    }
  }
}
