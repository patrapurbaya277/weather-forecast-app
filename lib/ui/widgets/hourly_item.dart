import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_forecast_app/service/models/weather.dart';

class HourlyItem extends StatelessWidget {
  final Current data;
  const HourlyItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.15,
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Text(
            "${data.temp}°",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Image.network("https://openweathermap.org/img/wn/${data.weather!.icon}.png"),
          Text(
            DateFormat("HH:mm").format(DateTime.fromMillisecondsSinceEpoch(data.dt!*1000)),
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}
