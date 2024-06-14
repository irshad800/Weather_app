import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/screens/HomeScreen.dart';
import 'package:weather_app/utils/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  double? lat;
  double? longt;
  var weatherData;
  TextEditingController location = TextEditingController();

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  void getlocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    print(position);
    setState(() {
      lat = position.latitude;
      longt = position.longitude;
    });
    fetchWeatherData(lat, longt);
  }

  Future<void> fetchWeatherData(double? lat, double? longt) async {
    if (lat != null || longt != null) {
      var response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey'));
      if (response.statusCode == 200)
        setState(() {
          weatherData = jsonDecode(response.body);
        });
      print(weatherData);
      return weatherData;
    } else {
      throw Exception('failed to load weather data');
    }
  }

  Future<void> searchWeather(String location) async {
    var response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey'));
    if (response.statusCode == 200) {
      setState(() {
        weatherData = jsonDecode(response.body);
      });
      print(weatherData);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  void initState() {
    getlocation();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/img_6.png'))),
            // Wrap your Column with a Container

            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WeatherHomePage(),
                            ));
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Weather",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    SizedBox(
                      width: 160,
                    ),
                    Icon(
                      Icons.more_horiz_outlined,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search for a city",
                      hintStyle: TextStyle(color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(CupertinoIcons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      fillColor: Colors.black26,
                      filled: true,
                    ),
                    onSubmitted: (value) {
                      searchWeather(value);
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (weatherData != null)
                  Container(
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/photo_2024-06-12_12-36-24-removebg-preview.png',
                          height: 200,
                          width: 400,
                        ),
                        Positioned(
                            right: -45,
                            bottom: -5,
                            child: Image.asset(
                              'assets/images/photo_2024-06-12_12-39-20-removebg-preview.png',
                              height: 260,
                              width: 260,
                            )),
                        Positioned(
                            left: 30,
                            top: 25,
                            child: Text(
                              '${((weatherData['main']['temp']) - 273.15).toStringAsFixed(0)}°',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            )),
                        Positioned(
                            left: 30,
                            top: 100,
                            child: Row(
                              children: [
                                Text(
                                  'H:${((weatherData['main']['humidity']) - 273.15).toStringAsFixed(0)}°',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'WS:${((weatherData['wind']['speed']) - 273.15).toStringAsFixed(0)}°',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                ),
                              ],
                            )),
                        Positioned(
                            left: 30,
                            top: 145,
                            child: Text(
                              '${((weatherData['name']))}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )),
                        Positioned(
                            right: 30,
                            top: 145,
                            child: Text(
                              '${((weatherData['weather'][0]['main']))}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )),
                      ],
                    ),
                  ),

                Container(
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/photo_2024-06-12_12-36-24-removebg-preview.png',
                        height: 200,
                        width: 400,
                      ),
                      Positioned(
                          right: -45,
                          bottom: -5,
                          child: Image.asset(
                            'assets/images/photo_2024-06-12_11-34-01-removebg-preview.png',
                            height: 260,
                            width: 260,
                          )),
                      Positioned(
                          left: 30,
                          top: 145,
                          child: Text(
                            "Toronto,canada",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )),
                      Positioned(
                          right: 30,
                          top: 145,
                          child: Text(
                            "Fast Wind",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )),
                      Positioned(
                          left: 30,
                          top: 25,
                          child: Text(
                            "20°",
                            style: TextStyle(color: Colors.white, fontSize: 60),
                          )),
                      Positioned(
                          left: 30,
                          top: 100,
                          child: Text(
                            "H:21° L:19°",
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          )),
                    ],
                  ),
                ),
                Container(
                  child: Stack(
                    children: [
                      Image.asset(
                        "assets/images/photo_2024-06-12_12-36-24-removebg-preview.png",
                        height: 200,
                        width: 400,
                      ),
                      Positioned(
                          right: -45,
                          bottom: -5,
                          child: Image.asset(
                            "assets/images/photo_2024-06-12_12-37-30-removebg-preview.png",
                            height: 260,
                            width: 260,
                          )),
                      Positioned(
                          left: 30,
                          top: 145,
                          child: Text(
                            "Tokyo,Japan",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )),
                      Positioned(
                          right: 30,
                          top: 145,
                          child: Text(
                            "Showers",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )),
                      Positioned(
                          left: 30,
                          top: 25,
                          child: Text(
                            "13°",
                            style: TextStyle(color: Colors.white, fontSize: 60),
                          )),
                      Positioned(
                          left: 30,
                          top: 100,
                          child: Text(
                            "H:18° L:8°",
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          )),
                    ],
                  ),
                )

                // Add more widgets here as needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}
