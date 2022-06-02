import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_forecast_app/service/models/weather.dart';

class Pref {
  static SharedPreferences? _pref;
  static DateTime? recentDate;
  static Weather? recentWeather;

  static load() async {
    Pref._pref = await SharedPreferences.getInstance();
    String? date = _pref!.getString("savedDate");
    String? weather = _pref!.getString("savedData");
    if (date != null) {
      recentDate = DateTime.parse(date);
    }
    if (weather != null) {
      recentWeather = Weather.fromJson(json.decode(weather));
    }
  }

  static save({required Weather weather, required DateTime date}) async {
    recentDate = date;
    recentWeather = weather;
    _pref = await SharedPreferences.getInstance();
    await _pref!.setString("savedDate", date.toString());
    await _pref!.setString("savedData", jsonEncode(weather));
  }
}
