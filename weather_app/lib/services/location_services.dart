// filepath: lib/services/location_service.dart
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  final Location _location = Location();

  Future<Map<String, dynamic>> getCurrentLocation() async {
    // Solicita permisos de ubicación
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        throw Exception('El servicio de ubicación está deshabilitado.');
      }
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception('Los permisos de ubicación fueron denegados.');
      }
    }

    // Obtiene la ubicación actual
    final locationData = await _location.getLocation();
    return {
      'latitude': locationData.latitude,
      'longitude': locationData.longitude,
    };
  }

  Future<String> getLocationName(double latitude, double longitude) async {
    const apiKey =
        '43201f42c6be4d379c6133011252404'; // Reemplaza con tu API Key de OpenCage
    final url =
        'https://api.opencagedata.com/geocode/v1/json?q=$latitude+$longitude&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'][0]['formatted']; // Devuelve el nombre de la ubicación
    } else {
      throw Exception('Error al obtener el nombre de la ubicación.');
    }
  }
}
