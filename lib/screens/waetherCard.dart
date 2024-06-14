import 'package:flutter/material.dart';

class WeatherCard extends StatefulWidget {
  final String time;
  final String temperature;
  final String chance;
  final String icon;

  const WeatherCard({
    Key? key,
    required this.time,
    required this.temperature,
    required this.chance,
    required this.icon,
  }) : super(key: key);

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white
          .withOpacity(0.3), // Adjust the card background color and opacity
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        color: Colors.blue.withOpacity(0.2),
        width: 80, // Adjust the width of the card as needed
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.time,
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            SizedBox(height: 8.0),
            Image.asset(
              'assets/images/${widget.icon}',
              width: 20,
              height: 16,
            ),
            SizedBox(height: 8.0),
            Text(
              '${widget.temperature}°C',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            SizedBox(height: 4.0),
            Text(
              widget.chance,
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }
}
