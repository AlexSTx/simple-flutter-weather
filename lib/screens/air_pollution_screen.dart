import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/controllers/air_pollution_controller.dart';

class AirPollutionScreen extends StatefulWidget {
  final double lat;
  final double lon;

  const AirPollutionScreen({
    super.key,
    required this.lat,
    required this.lon,
  });

  @override
  State<AirPollutionScreen> createState() => _AirPollutionScreenState();
}

class _AirPollutionScreenState extends State<AirPollutionScreen> {
  late Future<AirPollution> _airPollution;

  @override
  void initState() {
    _airPollution = fetchAirPollution(widget.lat, widget.lon);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _airPollution,
        builder: (BuildContext context, AsyncSnapshot<AirPollution> snapshot) {
          if (snapshot.hasData) {
            AirPollution pollution = snapshot.data!;

            return Scaffold(
              appBar: AppBar(title: const Text('Air Quality')),
              body: SafeArea(
                  child: Center(
                child: Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                              'Datetime: ${DateFormat('dd/MM/yyyy - HH:mm').format(pollution.date)}'),
                          const SizedBox(height: 10),
                          Text('Air Quality Index (AQI): ${pollution.airQualityIndex}'),
                          const SizedBox(height: 10),
                          Text('CO: ${pollution.co} μg/m³'),
                          const SizedBox(height: 10),
                          Text('NO: ${pollution.no} μg/m³'),
                          const SizedBox(height: 10),
                          Text('NO2: ${pollution.no2} μg/m³'),
                          const SizedBox(height: 10),
                          Text('O3: ${pollution.o3} μg/m³'),
                          const SizedBox(height: 10),
                          Text('SO2: ${pollution.so2} μg/m³'),
                          const SizedBox(height: 10),
                          Text('PM2.5: ${pollution.pm2_5} μg/m³'),
                          const SizedBox(height: 10),
                          Text('PM10: ${pollution.pm10} μg/m³'),
                          const SizedBox(height: 10),
                          Text('NH3: ${pollution.nh3} μg/m³'),
                        ],
                      ),
                    )),
              )),
            );
          } else {
            return Scaffold(
              appBar: AppBar(title: const CircularProgressIndicator()),
            );
          }
        });
  }
}
