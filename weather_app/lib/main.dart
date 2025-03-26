import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/services/weather_services.dart';
import 'screens/home_screen.dart';
import 'services/weather_services.dart';
import 'models/weather_data.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _weatherService = WeatherService();
  late Future<WeatherData> _weatherData;
  final String location = 'San Francisco, CA';
  final double lat = 37.7749; // San Francisco latitude
  final double lon = -122.4194; // San Francisco longitude

  @override
  void initState() {
    super.initState();
    _weatherData = _weatherService.fetchWeatherData(lat, lon);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherData>(
      future: _weatherData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return HomeScreen(weatherData: snapshot.data!, location: location);
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
