import 'package:weather_clean_architecture/domain/entities/latlng.dart';

class City {
  final String name;
  final LatLng coords;

  City({required this.name, required this.coords});
}
