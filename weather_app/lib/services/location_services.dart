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
    const apiKey = '43201f42c6be4d379c6133011252404';
    final url =
        'https://api.opencagedata.com/geocode/v1/json?q=$latitude+$longitude&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    print('Respuesta de la API: ${response.body}');
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

  static Future<String> getCurrentLocationName() async {
    final locationService = LocationService();
    try {
      final coordinates = await locationService.getCurrentLocation();
      print('Coordenadas obtenidas: $coordinates'); // Depuración
      final locationName = await locationService.getLocationName(
        coordinates['latitude']!,
        coordinates['longitude']!,
      );
      print('Nombre de la ubicación: $locationName'); // Depuración
      return locationName;
    } catch (e) {
      print('Error: $e'); // Depuración
      return 'Error al obtener la ubicación';
    }
  }
}
