import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_data.dart';
import 'weather_icon.dart';

class DailyForecastWidget extends StatelessWidget {
  final List<DailyForecast> daily;

  const DailyForecastWidget({super.key, required this.daily});

  @override
  Widget build(BuildContext context) {
    final blueShade200 = Colors.blue.shade200; // Moved outside constant context

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: const Color(0xFF1D1E33),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '7-DAY FORECAST',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: blueShade200, // Usamos la variable aquí
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            ...daily.map((day) => _buildDailyItem(day)),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyItem(DailyForecast day) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              DateFormat('EEEE').format(day.date),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: WeatherIcon(
              iconUrl: day.conditionIcon, // Usamos el getter
              size: 32,
            ),
          ),
          Expanded(
            child: Text(
              '${day.maxTempC.round()}°', // Usamos el getter
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              '${day.minTempC.round()}°', // Usamos el getter
              style: TextStyle(color: Colors.blue.shade300),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}