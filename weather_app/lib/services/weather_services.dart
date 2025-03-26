import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';
import '../constants/api_constants.dart';

class WeatherService {
  Future<WeatherData> fetchWeatherData(double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.oneCallEndpoint}?lat=$lat&lon=$lon&exclude=minutely,alerts&units=metric&appid=${ApiConstants.apiKey}',
      ),
    );

    if (response.statusCode == 200) {
      return WeatherData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
