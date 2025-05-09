import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:weather_app/services/location_services.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:weather_app/widgets/city_search_delegate.dart';
import 'saved_locations_screen.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  Future<WeatherData>? _weatherData;
  String _currentLocation = '';
  String _locationName = '';
  bool _isLoading = true;
  String? _error;
  bool _useFahrenheit = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

<<<<<<< HEAD
=======
<<<<<<< HEAD
  Future<void> _initializeApp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _useFahrenheit = prefs.getBool('useFahrenheit') ?? false;
      String? savedLocation = prefs.getString('savedLocation');

      if (savedLocation == null) {
        Position position = await _getCurrentLocation();
        savedLocation = '${position.latitude},${position.longitude}';
        await prefs.setString('savedLocation', savedLocation);
      }

      final parts = savedLocation.split(',');
      final lat = double.tryParse(parts[0]) ?? 0.0;
      final lon = double.tryParse(parts[1]) ?? 0.0;
      final name = await _locationService.getLocationName(lat, lon);

      setState(() {
        _currentLocation = savedLocation!;
        _locationName = name;
        _weatherData = _weatherService.fetchWeatherData(savedLocation);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al iniciar la app: $e';
        _isLoading = false;
      });
=======
>>>>>>> d5e05d3df7dc94e77017f44edc2249838fb819cd
Future<void> _initializeApp() async {
  try {
    final prefs = await SharedPreferences.getInstance();

    String? savedLocation = prefs.getString('savedLocation');
    if (savedLocation == null) {
      try {
        Position position = await _getCurrentLocation();
        savedLocation = '${position.latitude},${position.longitude}';
      } catch (e) {
        debugPrint('No se pudo obtener la ubicación actual. Usando valor por defecto.');
        savedLocation = 'Lleida';
      }
<<<<<<< HEAD
=======
>>>>>>> main
>>>>>>> d5e05d3df7dc94e77017f44edc2249838fb819cd
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
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Ubicación deshabilitada');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permiso permanente denegado');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _saveLocation(String location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedLocation', location);
  }

  Future<void> _toggleTempUnit() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useFahrenheit', !_useFahrenheit);
    setState(() {
      _useFahrenheit = !_useFahrenheit;
    });
  }

  void _navigateToSavedLocations() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SavedLocationsScreen(
          onCitySelected: (city) async {
            await _saveLocation(city);
            final parts = city.split(',');
            final lat = double.tryParse(parts[0]) ?? 0.0;
            final lon = double.tryParse(parts[1]) ?? 0.0;
            final name = await _locationService.getLocationName(lat, lon);

            setState(() {
              _currentLocation = city;
              _locationName = name;
              _weatherData = _weatherService.fetchWeatherData(city);
            });
          },
        ),
      ),
    );
  }

  void _openSearch() async {
    final selected = await showSearch<String>(
      context: context,
      delegate: CitySearchDelegate(locationService: _locationService),
    );

    if (selected != null && selected.isNotEmpty) {
      try {
        final weather = await _weatherService.fetchWeatherData(selected);
        final lat = weather.location.lat;
        final lon = weather.location.lon;
        final coordinate = '$lat,$lon';

        await _saveLocation(coordinate);
        final name = await _locationService.getLocationName(lat, lon);

        setState(() {
          _currentLocation = coordinate;
          _locationName = name;
          _weatherData = _weatherService.fetchWeatherData(coordinate);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al buscar ciudad: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(child: Text(_error ?? 'Error')),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: _navigateToSavedLocations,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _openSearch,
          ),
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () async {
              try {
                Position pos = await _getCurrentLocation();
                final loc = '${pos.latitude},${pos.longitude}';
                final name = await _locationService.getLocationName(pos.latitude, pos.longitude);
                await _saveLocation(loc);
                setState(() {
                  _currentLocation = loc;
                  _locationName = name;
                  _weatherData = _weatherService.fetchWeatherData(loc);
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
          ),
          IconButton(
            icon: Text(_useFahrenheit ? '°F' : '°C', style: const TextStyle(fontSize: 16)),
            onPressed: _toggleTempUnit,
          ),
        ],
      ),
      body: _weatherData == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<WeatherData>(
              future: _weatherData!,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return HomeScreen(
                    weatherData: snapshot.data!,
                    location: _locationName,
                    useFahrenheit: _useFahrenheit,
                  );
                } else {
                  return const Center(child: Text('Sin datos'));
                }
              },
            ),
    );
  }
}
