class ApiConstants {
  static const String baseUrl = 'https://api.weatherapi.com/v1';
  static const String forecastEndpoint = '/forecast.json';
  static const String apiKey = '43201f42c6be4d379c6133011252404';
  static const int forecastDays = 3;

  static String buildForecastUrl(String query) {
    return '$baseUrl$forecastEndpoint?key=$apiKey&q=$query&days=$forecastDays&aqi=no&alerts=no';
  }
}
