import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_data.dart';
import 'weather_icon.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final CurrentWeather current;
  final String location;

  const CurrentWeatherWidget({
    super.key,
    required this.current,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          location,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Now',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Text(
              '${current.temp.round()}°',
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'High: ${current.temp.round()}° • Low: ${current.feelsLike.round()}°',
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    WeatherIcon(iconCode: current.icon, size: 30),
                    const SizedBox(width: 8),
                    Text(
                      current.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Text('Feels like ${current.feelsLike.round()}°'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
