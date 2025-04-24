import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/screens/WeatherPage.dart';
import 'screens/home_screen.dart';
import 'services/weather_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    runApp(const MyApp());
  } catch (e) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error cargando configuración: $e')),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clima Simple',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.transparent, // Cambiado a transparente
        colorScheme: ColorScheme.dark(
          primary: const Color.fromARGB(
            255,
            255,
            255,
            255,
          ), // color lletres buscar ciudad
          secondary: const Color.fromARGB(255, 255, 255, 255),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: const Color.fromARGB(174, 55, 49, 87),
        ),
      ),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 56, 111, 167),
                Color.fromARGB(255, 116, 114, 117),
              ],
            ),
          ),
          child: const WeatherPage(),
        ),
      ),
    );
  }
}
