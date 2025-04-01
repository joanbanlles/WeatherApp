import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/screens/WeatherPage.dart';
import 'screens/home_screen.dart';
import 'services/weather_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Añade esta línea

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
        scaffoldBackgroundColor: const Color.fromARGB(
          200,
          12,
          53,
          163,
        ).withOpacity(0.5),
        colorScheme: ColorScheme.dark(
          primary: const Color.fromARGB(255, 9, 11, 12),
          secondary: const Color.fromARGB(255, 0, 0, 0),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: const Color(0xFF1D1E33),
        ),
      ),
      home: const WeatherPage(),
    );
  }
}
