import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_data.dart';
import 'weather_icon.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List<HourlyForecast> hourly;

  const HourlyForecastWidget({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hourly forecast',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hourly.length,
            itemBuilder: (context, index) {
              final hour = hourly[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Text(DateFormat('h a').format(hour.time)),
                    const SizedBox(height: 4),
                    WeatherIcon(iconUrl: hour.conditionIcon, size: 30),
                    const SizedBox(height: 4),
                    Text('${hour.tempC.round()}°'),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
