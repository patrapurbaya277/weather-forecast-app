import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_forecast_app/service/models/weather.dart';

class HourlyItem extends StatelessWidget {
  final Current data;
  final bool selected;
  const HourlyItem({Key? key, required this.data, required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
          border: Border.all(
              color: selected ? Colors.white : Colors.grey, width: 1.5),
          borderRadius: BorderRadius.circular(20),
          gradient: selected
              ? const LinearGradient(
                  colors: [
                    Color(0xff82DAF4),
                    Color(0xff126CF4),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${data.temp}°",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width / 24,
            ),
          ),
          Image.network(
            "https://openweathermap.org/img/wn/${data.weather!.icon}.png",
            errorBuilder: (context, child, stacktrace) =>
                const SizedBox(height: 20),
          ),
          Text(
            DateFormat("HH:mm")
                .format(DateTime.fromMillisecondsSinceEpoch(data.dt! * 1000)),
            style: TextStyle(color: selected ? Colors.white : Colors.grey),
          ),
        ],
      ),
    );
  }
}
