import 'package:equatable/equatable.dart';
import 'package:weather_clean_architecture/domain/entities/latlng.dart';
import 'package:weather_clean_architecture/domain/entities/weather.dart';
import 'package:weather_clean_architecture/foundation/data/weather_repository_interface.dart';
import 'package:weather_clean_architecture/foundation/domain/usecase.dart';

class GetWeather implements UseCase<Weather, CoordinateParams> {
  final WeatherRepositoryInterface _repository;

  GetWeather(this._repository);

  @override
  Future<Weather> call(params) async {
    return await _repository.getWeather(params.coords);
  }
}

class CoordinateParams extends Equatable {
  final LatLng coords;

  const CoordinateParams({required this.coords});

  @override
  List<Object?> get props => [coords];
}
