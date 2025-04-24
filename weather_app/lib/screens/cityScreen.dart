import 'package:flutter/material.dart';

class CityScreen extends StatelessWidget {
  final String cityName;
  final String weatherCondition;
  final int temperature;
  final int feelsLike;
  final int highTemp;
  final int lowTemp;
  final List<Map<String, dynamic>> hourlyForecast;
  final List<Map<String, dynamic>> dailyForecast;

  const CityScreen({
    super.key,
    required this.cityName,
    required this.weatherCondition,
    required this.temperature,
    required this.feelsLike,
    required this.highTemp,
    required this.lowTemp,
    required this.hourlyForecast,
    required this.dailyForecast,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cityName),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: buildGradientBackground(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Text(
              weatherCondition,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '$temperature°',
              style: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Feels like $feelsLike°',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'High $highTemp° · Low $lowTemp°',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: [
                  _buildHourlyForecast(),
                  const SizedBox(height: 20),
                  _buildDailyForecast(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourlyForecast() {
    // Validación para lista vacía
    if (hourlyForecast.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'No hay datos de pronóstico por horas disponibles',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Próximas horas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hourlyForecast.length,
            itemBuilder: (context, index) {
              final forecast = hourlyForecast[index];
              // Validación de campos requeridos
              final temp = forecast['temp']?.toString() ?? '--';
              final time = forecast['time']?.toString() ?? '--:--';

              Widget iconWidget;
              if (forecast['icon'] is IconData) {
                iconWidget = Icon(
                  forecast['icon'],
                  color: Colors.white,
                  size: 24,
                );
              } else if (forecast['icon'] is String &&
                  forecast['icon'].isNotEmpty) {
                iconWidget = Image.network(
                  forecast['icon'],
                  width: 24,
                  height: 24,
                  errorBuilder:
                      (context, error, stackTrace) => const Icon(
                        Icons.wb_sunny,
                        color: Colors.white,
                        size: 24,
                      ),
                );
              } else {
                iconWidget = const Icon(
                  Icons.wb_sunny,
                  color: Colors.white,
                  size: 24,
                );
              }

              return Container(
                width: 80,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$temp°',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    iconWidget,
                    const SizedBox(height: 5),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDailyForecast() {
    // Validación para lista vacía
    if (dailyForecast.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'No hay datos de pronóstico diario disponibles',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Próximos días',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dailyForecast.length,
          itemBuilder: (context, index) {
            final forecast = dailyForecast[index];
            // Validación de campos requeridos
            final day = forecast['day']?.toString() ?? '--';
            final high = forecast['high']?.toString() ?? '--';
            final low = forecast['low']?.toString() ?? '--';

            Widget iconWidget;
            if (forecast['icon'] is IconData) {
              iconWidget = Icon(
                forecast['icon'],
                color: Colors.white,
                size: 24,
              );
            } else if (forecast['icon'] is String &&
                forecast['icon'].isNotEmpty) {
              iconWidget = Image.network(
                forecast['icon'],
                width: 24,
                height: 24,
                errorBuilder:
                    (context, error, stackTrace) => const Icon(
                      Icons.wb_sunny,
                      color: Colors.white,
                      size: 24,
                    ),
              );
            } else {
              iconWidget = const Icon(
                Icons.wb_sunny,
                color: Colors.white,
                size: 24,
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    day,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Row(
                    children: [
                      iconWidget,
                      const SizedBox(width: 10),
                      Text(
                        '$high° / $low°',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  BoxDecoration buildGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromARGB(255, 56, 111, 167),
          Color.fromARGB(255, 116, 114, 117),
        ],
      ),
    );
  }
}
