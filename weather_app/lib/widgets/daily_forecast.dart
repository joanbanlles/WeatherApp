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
  final today = DateTime.now();
  final isToday = day.date.day == today.day &&
                  day.date.month == today.month &&
                  day.date.year == today.year;

  return Container(
    decoration: BoxDecoration(
      color: isToday ? Colors.blue.shade700.withOpacity(0.4) : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      border: isToday
          ? Border.all(color: Colors.white70, width: 1.2)
          : null,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              DateFormat('EEEE', 'es_ES').format(day.date),
              style: TextStyle(
                fontSize: 16,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: WeatherIcon(iconUrl: day.conditionIcon, size: 32),
          ),
          Expanded(
            child: Text(
              '${day.maxTempC.round()}°',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            child: Text(
              '${day.minTempC.round()}°',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue.shade300),
            ),
          ),
        ],
      ),
    ),
  );
}

}