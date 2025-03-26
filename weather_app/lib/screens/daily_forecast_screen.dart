import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_data.dart';
import '../widgets/daily_forecast.dart';

class DailyForecastScreen extends StatelessWidget {
  final List<DailyForecast> daily;

  const DailyForecastScreen({super.key, required this.daily});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('10-Day Forecast')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DailyForecastWidget(daily: daily),
      ),
    );
  }
}
