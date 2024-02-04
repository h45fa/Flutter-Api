import 'package:flutter/material.dart';
import 'package:load_add_edit/models/weather_model.dart';
import 'package:load_add_edit/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //
  final _weatherService =
      WeatherService(apiKey: 'API KEY');
  Weather? _weather;
  //
  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName ?? "loading..."),
            Text('${_weather?.temperature.round()}°C')
          ],
        ),
      ),
    );
  }
}
