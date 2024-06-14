import 'package:flutter/material.dart';

class WeatherInfoColumn extends StatelessWidget {
  final String? title;
  final String? value;
  final String? additionalInfo;
  final double? titlefontsze;
  final double? valuefontsze;
  final Color? colort;

  final IconData? icons;

  WeatherInfoColumn(
      {this.title,
      this.value,
      this.additionalInfo,
      this.icons,
      this.titlefontsze,
      this.valuefontsze,
      this.colort});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null)
          Text(
            title!,
            style: TextStyle(
              color: Colors.white,
              fontSize: titlefontsze,
            ),
          ),
        if (value != null)
          Text(
            value!,
            style: TextStyle(
              color: Colors.white,
              fontSize: valuefontsze,
            ),
          ),
        if (additionalInfo != null)
          Text(
            additionalInfo!,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        if (icons != null)
          Icon(
            icons,
            color: Colors.white70,
            size: 20,
          )
      ],
    );
  }
}
