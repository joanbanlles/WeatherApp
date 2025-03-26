import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_data.dart';
import 'weather_icon.dart';

class DailyForecastWidget extends StatelessWidget {
  final List<DailyForecast> daily;

  const DailyForecastWidget({super.key, required this.daily});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '10-day forecast',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...daily
            .map(
              (day) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('EEEE, MMM d').format(day.dt)),
                    Row(
                      children: [
                        WeatherIcon(iconCode: day.icon, size: 30),
                        const SizedBox(width: 8),
                        Text(
                          '${day.tempMax.round()}° / ${day.tempMin.round()}°',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}
