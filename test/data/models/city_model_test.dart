import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_clean_architecture/data/models/city_model.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  group(
    "City model tests",
    () {
      final jsonData = (jsonDecode(fixture("reverse_geocoding_response.json")) as List)[0];

      test('CityModel fromJson() creates CityModel instance correctly', () {
        // Call the fromJson() method
        final cityModel = CityModel.fromJson(jsonData);

        // Assert the created CityModel instance
        expect(cityModel.name, 'Mountain View');
        expect(cityModel.lat, 37.3893889);
        expect(cityModel.lon, -122.0832101);
      });

      test('CityModel toDomain() converts to City correctly', () {    
        // Create a CityModel instance from JSON
        final cityModel = CityModel.fromJson(jsonData);

        // Call the toDomain() method
        final city = cityModel.toDomain();

        // Assert the converted City object
        expect(city.name, 'Mountain View');
        expect(city.coords.lat, 37.3893889);
        expect(city.coords.lng, -122.0832101);
      });
    },
  );
}
