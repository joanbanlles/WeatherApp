import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_data.dart';
import '../widgets/current_weather.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/daily_forecast.dart';

class HomeScreen extends StatelessWidget {
  final WeatherData weatherData;
  final String location;

  const HomeScreen({
    super.key,
    required this.weatherData,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CurrentWeatherWidget(
              current: weatherData.current,
              location: location,
            ),
            const SizedBox(height: 24),
            HourlyForecastWidget(hourly: weatherData.hourly.take(24).toList()),
            const SizedBox(height: 24),
            DailyForecastWidget(daily: weatherData.daily),
          ],
        ),
      ),
    );
  }
}
