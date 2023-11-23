import 'package:flutter/material.dart';
import 'package:weather_app/controllers/weather_controller.dart';

class WeatherScreen extends StatefulWidget {
  final double lat;
  final double lon;

  const WeatherScreen({
    super.key,
    required this.lat,
    required this.lon,
  });

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Weather> _weather;

  @override
  void initState() {
    _weather = fetch5DayWeather(widget.lat, widget.lon);
    super.initState();
  }

  List<Widget> buildForecastCards(List<WeatherForecast> forecasts) {
    var cards = <Widget>[];

    String format(int num) => num.toString().padLeft(2, '0');

    for (var f in forecasts) {
      var dt = f.dateTime;
      var card = Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Text('${format(dt.day)}/${format(dt.month)}/${dt.year}'),
            const SizedBox(width: 10),
            Text('${format(dt.hour)}:${format(dt.minute)}'),
            const SizedBox(width: 10),
            Text('${f.tempMin} °C'),
            const SizedBox(width: 10),
            Text(f.description),
            const SizedBox(width: 10),
            Text(f.icon),
            const SizedBox(width: 10),
          ]),
        ),
      );
      cards.add(card);
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _weather,
        builder: (BuildContext context, AsyncSnapshot<Weather> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                  title:
                      Text('${snapshot.data!.cityInfo.name}, ${snapshot.data!.cityInfo.country}')),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var card in buildForecastCards(snapshot.data!.forecasts)) card,
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(title: const CircularProgressIndicator()),
            );
          }
        });
  }
}
