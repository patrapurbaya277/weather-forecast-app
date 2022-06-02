import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_forecast_app/service/models/weather.dart';
import 'package:weather_forecast_app/ui/children_page/dashboard_page.dart';

class DailyItem extends StatelessWidget {
  final Daily data;
  const DailyItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
      child: Row(
        children: [
          Text(
            DateFormat("EEEE")
                .format(DateTime.fromMillisecondsSinceEpoch(data.dt! * 1000)),
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  "https://openweathermap.org/img/wn/${data.weather!.icon}.png",
                  errorBuilder: (context, child, stacktrace) =>
                      const SizedBox(height: 20),
                ),
                Text(data.weather!.description!.capitalizeFirstofEach,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                    )),
              ],
            ),
          ),
          RichText(
              text: TextSpan(
            children: [
              TextSpan(
                  text: "+${data.temp!.max!.floor()}°",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              TextSpan(
                  text: " +${data.temp!.min!.floor()}°",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.5))),
            ],
          )),
        ],
      ),
    );
  }
}
