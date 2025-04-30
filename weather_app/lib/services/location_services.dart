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
    const apiKey = '946bdb8c833d4ec8982f0ed9cf784244'; // Reemplaza con tu API Key de OpenCage
    final url =
        'https://api.opencagedata.com/geocode/v1/json?q=$latitude+$longitude&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'][0]['components']['city'] ??
       data['results'][0]['components']['town'] ??
       data['results'][0]['components']['village'] ??
       data['results'][0]['components']['municipality'] ??
       data['results'][0]['components']['county'] ??
       data['results'][0]['components']['state'] ??
       'Ubicación desconocida';
    } else {
      throw Exception('Error al obtener el nombre de la ubicación.');
    }
  }

Future<List<String>> searchCitySuggestions(String query) async {
  const apiKey = '946bdb8c833d4ec8982f0ed9cf784244'; // tu API key
  final url =
      'https://api.opencagedata.com/geocode/v1/json?q=$query&key=$apiKey&limit=5&language=es';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final results = data['results'] as List<dynamic>;

    return results.map<String>((item) => item['formatted'] as String).toList();
  } else {
    throw Exception('Error al buscar sugerencias');
  }
}




}
