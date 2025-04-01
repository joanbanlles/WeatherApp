import 'package:flutter/material.dart';
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
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: const Color(0xFF1D1E33),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Now',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade200,
                        ),
                      ),
                    ],
                  ),
                  WeatherIcon(iconUrl: current.conditionIcon, size: 64),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${current.tempC.round()}°',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Feels like ${current.feelslikeC.round()}°',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade200,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8, // Reduce el espacio horizontal
                runSpacing: 4, // Reduce el espacio vertical
                children: [
                  _buildDetailItem(
                    Icons.water_drop,
                    'Humidity',
                    '${current.humidity}%',
                  ),
                  _buildDetailItem(
                    Icons.air,
                    'Wind',
                    '${current.windKph} km/h',
                  ),
                  _buildDetailItem(
                    Icons.light_mode,
                    'UV Index',
                    current.uv.toString(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.blue.shade300),
        const SizedBox(width: 4),
        Text('$label: ', style: TextStyle(color: Colors.blue.shade200)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
