import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CityInfo {
  final String name;
  final double lat;
  final double lon;
  final String country;
  final int population;
  final int timezone;
  final int sunrise;
  final int sunset;

  const CityInfo({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
    required this.population,
    required this.timezone,
    required this.sunrise,
    required this.sunset,
  });

  factory CityInfo.fromJson(Map<String, dynamic> json) {
    return CityInfo(
      name: json['name'],
      lat: json['coord']['lat'],
      lon: json['coord']['lon'],
      country: json['country'],
      population: json['population'],
      timezone: json['timezone'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }
}

class WeatherForecast {
  final DateTime dateTime;
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
      temp: json['main']['temp'].toDouble() as double,
      feelsLike: json['main']['feels_like'].toDouble() as double,
      tempMin: json['main']['temp_min'].toDouble() as double,
      tempMax: json['main']['temp_max'].toDouble() as double,
      pressure: json['main']['pressure'].toDouble() as double,
      humidity: json['main']['humidity'].toDouble() as double,
      mainWeatherStatus: json['weather'][0]['main'] as String,
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
    );
  }
}

class DailyWeather {
  late DateTime date;
  late double dailyTempMax;
  late double dailyTempMin;
  List<WeatherForecast> forecasts;

  DailyWeather({required this.forecasts}) {
    _setDailyTempMax();
    _setDailyTempMin();
    date = forecasts[0].dateTime;
  }

  void _setDailyTempMax() {
    double maxTemp = double.negativeInfinity;
    for (var f in forecasts) {
      if (maxTemp < f.tempMax) maxTemp = f.tempMax;
    }
    dailyTempMax = maxTemp;
  }

  void _setDailyTempMin() {
    double minTemp = double.infinity;
    for (var f in forecasts) {
      if (minTemp > f.tempMin) minTemp = f.tempMin;
    }
    dailyTempMin = minTemp;
  }
}

class Weather {
  List<DailyWeather> dailyForecasts = [];
  final CityInfo cityInfo;

  Weather(List<WeatherForecast> forecasts, {required this.cityInfo}) {
    var triHourlyForecasts = <WeatherForecast>[];
    DateTime date = forecasts[0].dateTime;

    for (var f in forecasts) {
      if (triHourlyForecasts.isNotEmpty && date.day != f.dateTime.day) {
        dailyForecasts.add(DailyWeather(forecasts: triHourlyForecasts));
        triHourlyForecasts = [];
      }
      triHourlyForecasts.add(f);
      date = f.dateTime;
    }

    if (triHourlyForecasts.isNotEmpty) {
      dailyForecasts.add(DailyWeather(forecasts: triHourlyForecasts));
    }
  }

  List<DailyWeather> getDailyForecasts() => dailyForecasts;
}

Future<Weather> fetch5DayWeather(double lat, double lon) async {
  print('$lat $lon');

  final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&units=metric&appid=${dotenv.env['API_KEY']}'));

  if (response.statusCode == 200) {
    var decodedResponse = jsonDecode(response.body);

    var forecasts = <WeatherForecast>[];
    var cityInfo = CityInfo.fromJson(decodedResponse['city']);

    for (var result in decodedResponse['list']) {
      forecasts.add(WeatherForecast.fromJson(result));
    }

    return Weather(forecasts, cityInfo: cityInfo);
  } else {
    throw Exception('Failed to fetch data for coordinates given');
  }
}
