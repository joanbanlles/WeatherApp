import 'package:flutter/material.dart';

class WeatherMetricsCard extends StatelessWidget {
  final int humidity;
  final double windKph;
  final double uv;

  const WeatherMetricsCard({
    super.key,
    required this.humidity,
    required this.windKph,
    required this.uv,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildItem(Icons.water_drop, 'Humedad', '$humidity%'),
            _buildItem(Icons.air, 'Viento', '${windKph.toStringAsFixed(1)} km/h'),
            _buildItem(Icons.wb_sunny, 'UV', uv.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.blue.shade300),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }
}
