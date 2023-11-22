import 'package:flutter/material.dart';
import 'package:weather_app/controllers/weather_controller.dart';

class WeatherScreen extends StatelessWidget {
  final Weather weather;

  const WeatherScreen({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(weather.cityInfo.name)),
    );
  }
}
