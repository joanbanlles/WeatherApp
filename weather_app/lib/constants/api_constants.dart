class ApiConstants {
  static const String baseUrl = 'https://api.weatherapi.com/v1';
  static const String forecastEndpoint = '/forecast.json';
  static const String apiKey = '2d0c32eecd0a4c148d8152442252703'; // Reemplaza con tu clave de WeatherAPI
  static const int forecastDays = 3; // Número de días para el pronóstico (máx. 14 en plan pago)
  
  // Método helper para construir la URL de la API
  static String buildForecastUrl(String query) {
    return '$baseUrl$forecastEndpoint?key=$apiKey&q=$query&days=$forecastDays&aqi=no&alerts=no';
  }
}