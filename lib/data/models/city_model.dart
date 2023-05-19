import 'package:weather_clean_architecture/domain/entities/city.dart';
import 'package:weather_clean_architecture/domain/entities/latlng.dart';

class CityModel {
  final String name;
  final double lat;
  final double lon;

  CityModel({
    required this.name,
    required this.lat,
    required this.lon,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      name: json["name"],
      lat: json["lat"],
      lon: json["lon"],
    );
  }

  City toDomain() {
    return City(
      name: name,
      coords: LatLng(lat: lat, lng: lon),
    );
  }
}
