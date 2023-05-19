import 'package:get_it/get_it.dart';
import 'package:weather_clean_architecture/data/repository/weather_repository_impl.dart';
import 'package:weather_clean_architecture/data/resources/remote/remote_weather_data_source_impl.dart';
import 'package:weather_clean_architecture/domain/use_cases/get_weather.dart';
import 'package:weather_clean_architecture/foundation/data/weather_data_source_interface.dart';
import 'package:weather_clean_architecture/foundation/data/weather_repository_interface.dart';
import 'package:http/http.dart' as http;

void init() {
  GetIt.I.registerLazySingleton(() => GetWeather(GetIt.instance()));

  GetIt.I.registerLazySingleton<WeatherRepositoryInterface>(
    () => WeatherRepositoryImpl(remoteDataSource: GetIt.instance()),
  );

  GetIt.I.registerLazySingleton<RemoteWeatherDataSourceInterface>(
    () => RemoteWeatherDataSourceImpl(GetIt.instance()),
  );

  GetIt.I.registerLazySingleton(() => http.Client());
}
