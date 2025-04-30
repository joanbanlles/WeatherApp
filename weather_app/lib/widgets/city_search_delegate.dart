import 'package:flutter/material.dart';
import 'package:weather_app/services/location_services.dart';

class CitySearchDelegate extends SearchDelegate<String> {
  final LocationService locationService;

  CitySearchDelegate({required this.locationService});

  @override
  String get searchFieldLabel => 'Buscar ciudad';

  @override
  TextInputType get keyboardType => TextInputType.text;

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) => const SizedBox.shrink();

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length < 2) return const Center(child: Text('Escribe una ciudad...'));

    return FutureBuilder<List<String>>(
      future: locationService.searchCitySuggestions(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No se encontraron resultados'));
        }

        final suggestions = snapshot.data!;
        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = suggestions[index];
            return ListTile(
              leading: const Icon(Icons.location_city),
              title: Text(suggestion),
              onTap: () => close(context, suggestion),
            );
          },
        );
      },
    );
  }
}
