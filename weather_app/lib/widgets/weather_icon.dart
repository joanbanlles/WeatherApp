import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WeatherIcon extends StatelessWidget {
  final String iconUrl;
  final double size;

  const WeatherIcon({
    super.key,
    required this.iconUrl,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: 'https:$iconUrl', // Corregida interpolación de string
      width: size,
      height: size,
      placeholder: (context, url) => SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
      errorWidget: (context, url, error) => Icon(
        Icons.error_outline,
        size: size,
        color: Colors.red.shade300,
      ),
    );
  }
}