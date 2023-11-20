import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherForecast {
  final DateTime? dateTime;
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final double pressure;
  final double humidity;
  final String mainWeatherStatus;
  final String description;
  final String icon;

  WeatherForecast({
    required this.dateTime,
    required this.mainWeatherStatus,
    required this.description,
    required this.icon,
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      temp: json['main']['temp'] as double,
      feelsLike: json['main']['feels_like'] as double,
      tempMin: json['main']['temp_min'] as double,
      tempMax: json['main']['temp_max'] as double,
      pressure: json['main']['pressure'] as double,
      humidity: json['main']['humidity'] as double,
      mainWeatherStatus: json['weather'][0]['main'] as String,
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
    );
  }
}

Future<List<WeatherForecast>> fetch5DayWeather(double lat, double lon) async {
  final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&units=metric&appid=${dotenv.env['API_KEY']}'));

  if (response.statusCode == 200) {
    var decodedResponse = jsonDecode(response.body);
    var forecasts = <WeatherForecast>[];

    for (var result in decodedResponse['list']) {
      forecasts.add(WeatherForecast.fromJson(result));
    }
    
    return forecasts;
  } else {
    throw Exception('Failed to fetch data for coordinates given');
  }
}
