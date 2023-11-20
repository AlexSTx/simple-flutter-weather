import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> fetch5DayWeather(double lat, double lon) async {
  final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&units=metric&appid=${dotenv.env['API_KEY']}'));

  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception('Failed to fetch data for coordinates given');
  }
}
