import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  List<Widget> buildForecastCards(List<DailyWeather> dailyForecasts) {
    var cards = <Widget>[];

    for (var df in dailyForecasts) {
      var card = Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(DateFormat('EEEE dd/MM/yyyy').format(df.date),
                        style: Theme.of(context).textTheme.bodyLarge),
                    const Spacer(),
                    Text('min: ${df.dailyTempMin}°C'),
                    const SizedBox(width: 8),
                    Text('max: ${df.dailyTempMax}°C'),
                  ],
                ),
              ),
              const Divider(
                color: Colors.white,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var f in df.forecasts)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: SizedBox(
                          width: 110,
                          child: Column(
                            children: [
                              Text(DateFormat('HH:mm').format(f.dateTime)),
                              Image.asset('assets/icons/${f.icon}.png', width: 32),
                              Text(f.description),
                              Text('${f.temp} °C'),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
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
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Column(
                        children: [
                          for (var card in buildForecastCards(snapshot.data!.dailyForecasts)) card,
                        ],
                      ),
                    ),
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
