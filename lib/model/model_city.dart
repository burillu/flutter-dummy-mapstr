import 'package:google_maps_flutter/google_maps_flutter.dart';

class ModelCity {
  final String name;
  final LatLng latLng;

  const ModelCity({required this.name, required this.latLng});
}

const List<ModelCity> cities = [
  ModelCity(name: "Nikšić", latLng: LatLng(42.77328100, 18.94866000)),
  ModelCity(name: "Casnate con Bernate", latLng: LatLng(45.7558411, 9.0737691)),
  ModelCity(name: "Cagliari", latLng: LatLng(39.227779, 9.111111)),
  ModelCity(name: "Roma", latLng: LatLng(41.902782, 12.496366)),
];
