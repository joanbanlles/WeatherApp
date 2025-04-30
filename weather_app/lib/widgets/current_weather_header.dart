import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/weather_data.dart';

class CurrentWeatherHeader extends StatefulWidget {
  final CurrentWeather current;

  const CurrentWeatherHeader({super.key, required this.current});

  @override
  State<CurrentWeatherHeader> createState() => _CurrentWeatherHeaderState();
}

class _CurrentWeatherHeaderState extends State<CurrentWeatherHeader> {
  late String imageAsset;

  @override
  void didUpdateWidget(covariant CurrentWeatherHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.current.condition.text != widget.current.condition.text) {
      imageAsset = _getImageAssetFromCondition(widget.current.condition.text);
    }
  }

  @override
  void initState() {
    super.initState();
    imageAsset = _getImageAssetFromCondition(widget.current.condition.text);
  }

  String _getImageAssetFromCondition(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('rain')) return 'assets/images/rainy.jpg';
    if (lower.contains('cloud')) return 'assets/images/cloudy.jpg';
    if (lower.contains('clear') || lower.contains('sun')) return 'assets/images/sunny.jpg';
    if (lower.contains('snow')) return 'assets/images/snow.jpg';
    return 'assets/images/default.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(imageAsset),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black.withOpacity(0.4),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.current.tempC.round()}°',
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: 'https:${widget.current.condition.icon}',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.current.condition.text,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
