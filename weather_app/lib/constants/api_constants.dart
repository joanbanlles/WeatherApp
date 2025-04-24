class ApiConstants {
  static const String baseUrl = 'https://api.weatherapi.com/v1';
  static const String forecastEndpoint = '/forecast.json';
  static const String apiKey = '43201f42c6be4d379c6133011252404'; // Reemplaza con tu clave de WeatherAPI
  static const int forecastDays = 3; // Número de días para el pronóstico (máx. 14 en plan pago)
  
  // Método helper para construir la URL de la API
  static String buildForecastUrl(String query) {
    return '$baseUrl$forecastEndpoint?key=$apiKey&q=$query&days=$forecastDays&aqi=no&alerts=no';
  }
}