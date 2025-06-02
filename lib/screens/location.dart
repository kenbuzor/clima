import 'package:clima/screens/city.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, required this.weatherData});

  final dynamic weatherData;
  @override
  State<LocationScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  int? temperature;
  int? condition;
  String? cityName;
  String? message;
  String? weatherIcon;

  @override
  void initState() {
    super.initState();
    updateUI(widget.weatherData);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'Error';
        message = 'Unable to get weather data';
        cityName = '';

        return;
      }
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();

      condition = weatherData['weather'][0]['id'];
      cityName = weatherData['name'];
      message = weatherModel.getMessage(temperature!);
      weatherIcon = weatherModel.getWeatherIcon(condition!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withValues(alpha: 0.8),
              BlendMode.dstATop,
            ),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      WeatherModel weatherModel = WeatherModel();
                      final weatherData =
                          await weatherModel.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: const Icon(Icons.near_me, size: 50.0),
                  ),
                  TextButton(
                    onPressed: () async {
                      final cityName = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => const CityScreen()),
                      );

                      if (cityName != null) {
                        WeatherModel weatherModel = WeatherModel();
                        final weatherData = await weatherModel
                            .getLocationByCityName(cityName);

                        updateUI(weatherData);
                      }
                    },
                    child: const Icon(Icons.location_city, size: 50.0),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text('$temperature°', style: kTempTextStyle),
                    Text(weatherIcon!, style: kConditionTextStyle),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  '$message in $cityName!',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
