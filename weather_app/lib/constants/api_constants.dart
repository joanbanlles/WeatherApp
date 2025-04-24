class ApiConstants {
  static const String baseUrl = 'https://api.weatherapi.com/v1';
  static const String forecastEndpoint = '/forecast.json';
  static const String apiKey =
      '32226f5ba1c14fdbaca151223251004'; // Reemplaza con tu clave de WeatherAPI
  static const int forecastDays =
      3; // Número de días para el pronóstico (máx. 14 en plan pago)

  // Método helper para construir la URL de la API
  static String buildForecastUrl(String query) {
    return '$baseUrl$forecastEndpoint?key=$apiKey&q=$query&days=$forecastDays&aqi=no&alerts=no';
  }
}
