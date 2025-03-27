// services/weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';

class WeatherService {
  Future<WeatherData> fetchWeatherData(String query) async {
    final response = await http.get(
      Uri.parse(
        'https://api.weatherapi.com/v1/forecast.json?key=2d0c32eecd0a4c148d8152442252703&q=$query&days=7&aqi=no&alerts=no',
      ),
    );

    if (response.statusCode == 200) {
      return WeatherData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data: ${response.statusCode}');
    }
  }
}