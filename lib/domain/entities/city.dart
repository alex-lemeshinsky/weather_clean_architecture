import 'package:equatable/equatable.dart';
import 'package:weather_clean_architecture/domain/entities/latlng.dart';

class City extends Equatable {
  final String name;
  final LatLng coords;

  const City({required this.name, required this.coords});

  @override
  List<Object?> get props => [name, coords];
}
