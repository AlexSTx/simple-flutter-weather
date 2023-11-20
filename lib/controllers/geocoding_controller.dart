//

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Position {
  final String name;
  final double lat;
  final double lon;
  final String country;
  final String? state;

  const Position({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
    this.state,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
        name: json['name'] as String,
        lat: json['lat'] as double,
        lon: json['lon'] as double,
        country: json['country'] as String,
        state: json['state'] != null ? json['state'] as String : '');
  }
}

Future<List<Position>> fetchPositions(String cityName) async {
  final response = await http.get(Uri.parse(
      'http://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=5&appid=${dotenv.env['API_KEY']}'));

  var positions = <Position>[];

  if (response.statusCode == 200) {
    var decodedResponse = jsonDecode(response.body) as List<dynamic>;

    for (var city in decodedResponse) {
      positions.add(Position.fromJson(city));
    }

    return positions;
  } else {
    throw Exception('Failed to fetch city coodinates');
  }
}
