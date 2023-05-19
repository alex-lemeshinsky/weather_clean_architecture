import 'package:equatable/equatable.dart';

class LatLng extends Equatable {
  final double lat;
  final double lng;

  const LatLng({required this.lat, required this.lng});

  @override
  List<Object?> get props => [lat, lng];
}
