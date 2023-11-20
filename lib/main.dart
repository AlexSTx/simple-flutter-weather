import 'package:flutter/material.dart';
import 'package:weather_app/screens/search_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'controllers/geocoding_controller.dart';

Future main() async {
  await dotenv.load(fileName: '.env');

  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 25, 43, 80)),
        useMaterial3: true,
      ),
      home: SearchScreen(),
    );
  }
}
