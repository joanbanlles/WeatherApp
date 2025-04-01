import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:geolocator/geolocator.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _weatherService = WeatherService();
  late Future<WeatherData> _weatherData;
  String _currentLocation = 'Lleida';
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Obtén la ubicación guardada o la ubicación actual
      String? savedLocation = prefs.getString('savedLocation');
      if (savedLocation == null) {
        Position position = await _getCurrentLocation();
        savedLocation = '${position.latitude},${position.longitude}';
      }

      setState(() {
        _currentLocation = savedLocation!;
        _weatherData = _weatherService.fetchWeatherData(_currentLocation);
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('Error inicializando: $e');
      debugPrint('StackTrace: $stackTrace');
      setState(() {
        _error = 'Error inicializando: $e';
        _isLoading = false;
      });
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica si el servicio de ubicación está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(
        'El servicio de ubicación está deshabilitado. Por favor, habilítalo.',
      );
    }

    // Verifica los permisos de ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Los permisos de ubicación fueron denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Los permisos de ubicación están permanentemente denegados. '
        'Por favor, habilítalos en la configuración del dispositivo.',
      );
    }

    // Obtén la ubicación actual
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _saveLocation(String location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedLocation', location);
  }

  void _showSearchDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Buscar ciudad'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'Ej: Barcelona, ES'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  if (controller.text.isNotEmpty) {
                    Navigator.pop(context);
                    await _saveLocation(controller.text);
                    if (mounted) {
                      setState(() {
                        _currentLocation = controller.text;
                        _weatherData = _weatherService.fetchWeatherData(
                          _currentLocation,
                        );
                      });
                    }
                  }
                },
                child: const Text('Buscar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 50, color: Colors.red),
              const SizedBox(height: 16),
              Text(_error!),
              TextButton(
                onPressed: _initializeApp,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima Simple'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () async {
              try {
                Position position = await _getCurrentLocation();
                String currentLocation =
                    '${position.latitude},${position.longitude}';

                await _saveLocation(currentLocation);
                setState(() {
                  _currentLocation = currentLocation;
                  _weatherData = _weatherService.fetchWeatherData(
                    _currentLocation,
                  );
                });
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<WeatherData>(
        future: _weatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  TextButton(
                    onPressed: _initializeApp,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            return HomeScreen(
              weatherData: snapshot.data!,
              location: _currentLocation,
            );
          } else {
            return const Center(child: Text('No hay datos disponibles'));
          }
        },
      ),
    );
  }
}
