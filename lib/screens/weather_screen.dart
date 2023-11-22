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
                child: Column(
                  children: [
                    SelectableText(
                      '(${widget.lat}, ${widget.lon})',
                      enableInteractiveSelection: true,
                    ),
                  ],
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
