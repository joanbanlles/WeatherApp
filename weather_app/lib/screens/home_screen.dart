import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/screens/cityScreen.dart';
import '../models/weather_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/screens/cityScreen.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String? locationName;

  @override
  void initState() {
    super.initState();
    _fetchLocationName();
  }

  Future<void> _fetchLocationName() async {
    try {
      final name = await WeatherData.getCurrentLocationName();
      setState(() {
        locationName = name;
      });
    } catch (e) {
      setState(() {
        locationName = 'Error al obtener la ubicación';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather App')),
      body:
          locationName == null
              ? Center(child: CircularProgressIndicator())
              : HomeScreen(
                weatherData: WeatherData(
                  location: Location(
                    name: locationName!, // Pasa el nombre de la ubicación aquí
                    region: 'Región desconocida',
                    country: 'País desconocido',
                    lat: 0.0,
                    lon: 0.0,
                  ),
                  current: CurrentWeather(
                    tempC: 20.0,
                    feelslikeC: 20.0,
                    condition: WeatherCondition(
                      text: 'Despejado',
                      icon: '//cdn.weatherapi.com/weather/64x64/day/113.png',
                    ),
                    windKph: 10.0,
                    humidity: 50,
                    uv: 5.0,
                  ),
                  hourly: [],
                  daily: [],
                ),
                location: locationName!,
              ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final WeatherData weatherData;
  final String location;

  const HomeScreen({
    super.key,
    required this.weatherData,
    required this.location,
    String? locationName,
    String? locationRegion,
    String? locationCountry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: buildGradientBackground(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLocationHeader(),
              const SizedBox(height: 24),
              _buildCurrentWeatherCard(context, weatherData.current),
              const SizedBox(height: 24),
              if (weatherData.hourly.isNotEmpty)
                _buildHourlyForecast(weatherData.hourly),
              const SizedBox(height: 24),
              if (weatherData.daily.isNotEmpty)
                _buildDailyForecast(weatherData.daily),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          location, // Aquí se mostrará el nombre de la ubicación
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          DateFormat('EEEE, d MMMM').format(DateTime.now()),
          style: TextStyle(fontSize: 16, color: Colors.blue.shade200),
        ),
      ],
    );
  }

  Widget _buildCurrentWeatherCard(
    BuildContext context,
    CurrentWeather current,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => CityScreen(
                  cityName: location,
                  weatherCondition: current.condition.text,
                  temperature: current.tempC.round(),
                  feelsLike: current.feelslikeC.round(),
                  highTemp: 25, // Reemplaza con datos reales
                  lowTemp: 15, // Reemplaza con datos reales
                  hourlyForecast: [], // Reemplaza con datos reales
                  dailyForecast: [], // Reemplaza con datos reales
                ),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${current.tempC.round()}°',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        current.condition.text,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  CachedNetworkImage(
                    imageUrl: 'https:${current.condition.icon}',
                    width: 80,
                    height: 80,
                    placeholder:
                        (context, url) => const CircularProgressIndicator(),
                    errorWidget:
                        (context, url, error) => const Icon(Icons.error),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWeatherDetail(Icons.water_drop, '${current.humidity}%'),
                  _buildWeatherDetail(Icons.air, '${current.windKph} km/h'),
                  _buildWeatherDetail(Icons.wb_sunny, '${current.uv}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String value) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.blue.shade300),
        const SizedBox(height: 4),
        Text(value),
      ],
    );
  }

  Widget _buildHourlyForecast(List<HourlyForecast> hourly) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Próximas horas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hourly.length,
            itemBuilder: (context, index) {
              final hour = hourly[index];
              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(DateFormat('ha').format(hour.time)),
                        const SizedBox(height: 4),
                        CachedNetworkImage(
                          imageUrl: 'https:${hour.condition.icon}',
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(height: 4),
                        Text('${hour.tempC.round()}°'),
                      ],
                    ),
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
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        ...daily.map(
          (day) => Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(DateFormat('EEEE').format(day.date)),
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
                      '${day.day.maxtempC.round()}°',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${day.day.mintempC.round()}°',
                      style: TextStyle(color: Colors.blue.shade300),
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
    BoxDecoration buildGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromARGB(255, 10, 76, 143),
          Color.fromARGB(255, 45, 44, 46),
        ],
      ),
    );
  }

}
