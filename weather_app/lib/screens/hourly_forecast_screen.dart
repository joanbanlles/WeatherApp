import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_data.dart';
import '../widgets/hourly_forecast.dart';

class HourlyForecastScreen extends StatelessWidget {
  final List<HourlyForecast> hourly;

  const HourlyForecastScreen({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hourly Forecast')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: HourlyForecastWidget(hourly: hourly),
      ),
    );
  }
}
