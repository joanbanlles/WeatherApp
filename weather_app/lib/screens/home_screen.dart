import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:weather_app/models/weather_data.dart';

class HomeScreen extends StatefulWidget {
  final WeatherData weatherData;
  final String location;
  final bool useFahrenheit;

  const HomeScreen({
    super.key,
    required this.weatherData,
    required this.location,
    required this.useFahrenheit,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _hourScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrentHour());
  }

  void _scrollToCurrentHour() {
    final now = DateTime.now();
    final index = widget.weatherData.hourly.indexWhere(
      (h) =>
          h.time.hour == now.hour &&
          h.time.day == now.day &&
          h.time.month == now.month &&
          h.time.year == now.year,
    );

    if (index != -1) {
      final itemWidth = 80.0 + 8.0;
      final screenWidth = MediaQuery.of(context).size.width;
      final offset = (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
      _hourScrollController.jumpTo(offset.clamp(0, _hourScrollController.position.maxScrollExtent));
    }
  }

  String _temp(double c) {
    return widget.useFahrenheit
        ? '${((c * 9 / 5) + 32).round()}°F'
        : '${c.round()}°C';
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.weatherData.current;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationHeader(),
          const SizedBox(height: 24),
          _buildCurrentWeatherCard(current),
          const SizedBox(height: 24),
          _buildHourlyForecast(widget.weatherData.hourly),
          const SizedBox(height: 24),
          _buildDailyForecast(widget.weatherData.daily),
        ],
      ),
    );
  }

  Widget _buildLocationHeader() {
    return Center(
      child: Column(
        children: [
          Text(
            widget.location,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            DateFormat('EEEE, d MMMM', 'es_ES').format(DateTime.now()),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

Widget _buildCurrentWeatherCard(CurrentWeather current) {
  String _getImageAssetFromCondition(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('rain')) return 'assets/images/rainy.jpg';
    if (lower.contains('cloud')) return 'assets/images/cloudy.jpg';
    if (lower.contains('clear') || lower.contains('sun')) return 'assets/images/sunny.jpg';
    if (lower.contains('snow')) return 'assets/images/snow.jpg';
    return 'assets/images/default.jpg';
  }

  final imageAsset = _getImageAssetFromCondition(current.condition.text);

  return Column(
    children: [
      Container(
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
                  _temp(current.tempC),
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
                      imageUrl: 'https:${current.condition.icon}',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      current.condition.text,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),
      Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherDetail(Icons.water_drop, 'Humedad', '${current.humidity}%'),
              _buildWeatherDetail(Icons.air, 'Viento', '${current.windKph.toStringAsFixed(1)} km/h'),
              _buildWeatherDetail(Icons.wb_sunny, 'UV', '${current.uv}'),
            ],
          ),
        ),
      ),
    ],
  );
}


  Widget _buildWeatherDetail(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.blue.shade300),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _buildHourlyForecast(List<HourlyForecast> hourly) {
    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Próximas horas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.separated(
            controller: _hourScrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: hourly.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final hour = hourly[index];
              final isNow = hour.time.hour == now.hour && hour.time.day == now.day;

              return Container(
                width: 80,
                decoration: BoxDecoration(
                  color: isNow ? Colors.white : const Color(0xFF1D1E33),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isNow
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(hour.time),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isNow ? Colors.black : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      CachedNetworkImage(
                        imageUrl: 'https:${hour.condition.icon}',
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _temp(hour.tempC),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isNow ? Colors.black : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDailyForecast(List<DailyForecast> daily) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Próximos días',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        ...daily.map(
          (day) => Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      DateFormat('EEEE', 'es_ES').format(day.date),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: 'https:${day.day.condition.icon}',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _temp(day.day.maxtempC),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _temp(day.day.mintempC),
                      style: TextStyle(color: Colors.blue.shade300),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
