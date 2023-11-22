import 'package:flutter/material.dart';
import 'package:weather_app/screens/weather_screen.dart';
import '../controllers/geocoding_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? _text;
  List<Position> cities = [];
  bool _searchFailed = false;

  void _searchHasFailed() {
    setState(() {
      _searchFailed = true;
      cities.clear();
    });
  }

  void _search(String? city) async {
    if (city == null || city == '') {
      setState(() => cities.clear());
      return;
    }

    try {
      var positions = await fetchPositions(city);

      if (positions.isEmpty) {
        _searchHasFailed();
      } else {
        setState(() {
          cities = positions;
          _searchFailed = false;
        });
      }
    } catch (err) {
      _searchHasFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Weather App')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  onSubmitted: (value) => _search(value),
                  onChanged: (value) => setState(() {
                    _text = value;
                    _searchFailed = false;
                  }),
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Enter city name',
                      suffixIcon: IconButton(
                        onPressed: () => _search(_text),
                        icon: const Icon(Icons.search),
                      )),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (_searchFailed) Text('No results for $_text'),
                    for (var city in cities) CitySearchResult(city: city),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

class CitySearchResult extends StatelessWidget {
  const CitySearchResult({
    super.key,
    required this.city,
  });

  final Position city;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${city.name}${city.state != '' ? ', ' : ''}${city.state}'),
      subtitle: Text(city.country),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_outward),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WeatherScreen(lat: city.lat, lon: city.lon)),
          );
        },
      ),
    );
  }
}
