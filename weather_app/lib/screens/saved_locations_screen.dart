import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:weather_app/services/location_services.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:weather_app/widgets/city_search_delegate.dart';

class SavedLocationsScreen extends StatefulWidget {
  final Function(String) onCitySelected;

  const SavedLocationsScreen({super.key, required this.onCitySelected});

  @override
  State<SavedLocationsScreen> createState() => _SavedLocationsScreenState();
}

class _SavedLocationsScreenState extends State<SavedLocationsScreen> {
  List<String> cities = [];
  Map<String, WeatherData> weatherDataMap = {};
  final TextEditingController _controller = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  List<String> _suggestions = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCities();
  }

  Future<void> _loadSavedCities() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('savedCities') ?? [];
    setState(() => cities = saved);
    for (String city in saved) {
      final weather = await _weatherService.fetchWeatherData(city);
      setState(() {
        weatherDataMap[city] = weather;
      });
    }
  }

  Future<void> _addCity(String city) async {
    if (city.isEmpty || cities.contains(city)) return;

    try {
      final weather = await _weatherService.fetchWeatherData(city);
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        cities.add(city);
        weatherDataMap[city] = weather;
        _suggestions.clear();
        _controller.clear();
        _isSearching = false;
      });

      await prefs.setStringList('savedCities', cities);
    } catch (e) {
      _showInvalidCityPopup(city);
    }
  }

  Future<void> _removeCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    cities.remove(city);
    await prefs.setStringList('savedCities', cities);
    setState(() {
      weatherDataMap.remove(city);
    });
  }

  Future<void> _getSuggestions(String input) async {
    if (input.length < 2) {
      setState(() => _suggestions.clear());
      return;
    }

    try {
      final results = await _locationService.searchCitySuggestions(input);
      setState(() => _suggestions = results);
    } catch (_) {
      setState(() => _suggestions = []);
    }
  }

  void _showInvalidCityPopup(String city) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ciudad inválida'),
        content: Text('No se ha encontrado la ciudad "$city". Intenta con otra.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  String _getImageAsset(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('rain')) return 'assets/images/rainy.jpg';
    if (lower.contains('cloud')) return 'assets/images/cloudy.jpg';
    if (lower.contains('sun') || lower.contains('clear')) return 'assets/images/sunny.jpg';
    if (lower.contains('snow')) return 'assets/images/snow.jpg';
    return 'assets/images/default.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ciudades Guardadas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final selected = await showSearch<String>(
                      context: context,
                      delegate: CitySearchDelegate(locationService: _locationService),
                    );

                    if (selected != null && selected.isNotEmpty) {
                      _addCity(selected);
                    }
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar ciudad'),
                ),
                if (_suggestions.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = _suggestions[index];
                        return ListTile(
                          title: Text(suggestion),
                          onTap: () => _addCity(suggestion),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: cities.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final city = cities[index];
                final weather = weatherDataMap[city];

                return GestureDetector(
                  onTap: () async {
                    try {
                      final weather = await _weatherService.fetchWeatherData(city);
                      final lat = weather.location.lat;
                      final lon = weather.location.lon;
                      final coordinate = '$lat,$lon';
                      widget.onCitySelected(coordinate);
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No se pudo cargar el clima para "$city"')),
                      );
                    }
                  },
                  child: Container(
                    height: 130,
                    decoration: BoxDecoration(
                      image: weather != null
                          ? DecorationImage(
                              image: AssetImage(_getImageAsset(weather.current.condition.text)),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.4),
                                BlendMode.darken,
                              ),
                            )
                          : null,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      title: Text(
                        city,
                        style: const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      subtitle: weather != null
                          ? Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: 'https:${weather.current.condition.icon}',
                                  width: 30,
                                  height: 30,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${weather.current.tempC.round()}°C  ${weather.current.condition.text}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            )
                          : const Text(
                              'Cargando clima...',
                              style: TextStyle(color: Colors.white70),
                            ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _removeCity(city),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
