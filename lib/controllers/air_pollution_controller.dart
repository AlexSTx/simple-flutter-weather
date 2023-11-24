import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AirPollution {
  final DateTime date;
  final int airQualityIndex;
  final double co;
  final double no;
  final double no2;
  final double o3;
  final double so2;
  final double pm2_5;
  final double pm10;
  final double nh3;

  const AirPollution({
    required this.date,
    required this.airQualityIndex,
    required this.co,
    required this.no,
    required this.no2,
    required this.o3,
    required this.so2,
    required this.pm2_5,
    required this.pm10,
    required this.nh3,
  });

  factory AirPollution.fromJson(Map<String, dynamic> json) {
    return AirPollution(
      date: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      airQualityIndex: json['main']['aqi'] as int,
      co: json['components']['co'].toDouble(),
      no: json['components']['no'].toDouble(),
      no2: json['components']['no2'].toDouble(),
      o3: json['components']['o3'].toDouble(),
      so2: json['components']['so2'].toDouble(),
      pm2_5: json['components']['pm2_5'].toDouble(),
      pm10: json['components']['pm10'].toDouble(),
      nh3: json['components']['nh3'].toDouble(),
    );
  }
}

Future<AirPollution> fetchAirPollution(double lat, double lon) async {
  final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/air_pollution/forecast?lat=$lat&lon=$lon&appid=${dotenv.env['API_KEY']}'));

  if (response.statusCode == 200) {
    var decodedResponse = jsonDecode(response.body);
    return AirPollution.fromJson(decodedResponse['list'][0]);
  } else {
    throw Exception('Failed to fetch air pollution data for coordinates given');
  }
}
