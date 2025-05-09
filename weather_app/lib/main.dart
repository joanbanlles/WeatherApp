import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/WeatherPage.dart';
import 'package:intl/date_symbol_data_local.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('es_ES', null); // << NECESARIO
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: 'Clima Simple',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
            primary: Color.fromARGB(255, 10, 76, 143),
            secondary: Color.fromARGB(255, 45, 44, 46),
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
      ),
    );
  }
}

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: buildGradientBackground(),
        child: Center(
          child: Text('Weather Page', style: TextStyle(color: Colors.white)),
        ),
      ),
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
