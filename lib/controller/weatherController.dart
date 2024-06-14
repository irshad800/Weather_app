import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/WeatherDataa.dart';

import '../utils/constants.dart';

Future<bool> handleLocationPermission({required BuildContext context}) async {
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

Future<Position> getlocation({required BuildContext context}) async {
  final hasPermission = await handleLocationPermission(context: context);
  if (!hasPermission) throw 'error';
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low);
  print(position);
  return position;
}

Future<WeatherDataa> WeatherS(
    {required double? lat, required double? longt}) async {
  if (lat != null && longt != null) {
    try {
      var response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$longt&appid=$apiKey'));
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);

        WeatherDataa _weather1 = WeatherDataa.fromJson(decoded);
        print('Weather Data: ${_weather1.toString()}');
        return _weather1;
      } else {
        throw Exception(
            'Failed to load weather data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error retrieving weather data: $e');
      throw Exception('Error retrieving weather data: $e');
    }
  } else {
    throw Exception('Latitude or Longitude is null');
  }
}
