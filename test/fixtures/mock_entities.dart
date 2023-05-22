import 'package:geolocator/geolocator.dart';
import 'package:weather_clean_architecture/domain/entities/city.dart';
import 'package:weather_clean_architecture/domain/entities/latlng.dart';
import 'package:weather_clean_architecture/domain/entities/weather.dart';
import 'package:weather_clean_architecture/domain/entities/weather_data.dart';
import 'package:weather_icons/weather_icons.dart';

const mockCity = City(
  name: 'San Francisco',
  coords: LatLng(lat: 37.7749, lng: -122.4194),
);

final mockWeatherData = WeatherData(
  temp: 1,
  windSpeed: 1,
  windDeg: 1,
  description: "description",
  icon: WeatherIcons.day_sunny,
  dateTime: DateTime.fromMillisecondsSinceEpoch(500, isUtc: true),
);

final mockWeather = Weather(
  city: mockCity,
  currentWeather: mockWeatherData,
  hourlyForecast: [mockWeatherData],
  dailyForecast: [mockWeatherData],
);

const mockPosition = Position(
  latitude: 37.7749,
  longitude: -122.4194,
  timestamp: null,
  accuracy: 0.0,
  altitude: 0.0,
  heading: 0.0,
  speed: 0.0,
  speedAccuracy: 0.0,
);
