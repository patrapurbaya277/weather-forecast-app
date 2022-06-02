import 'package:weather_forecast_app/service/api/weather_service.dart';
import 'package:weather_forecast_app/service/local/pref.dart';
import 'package:weather_forecast_app/service/models/weather.dart';

class WeatherRepository {
  WeatherService service = WeatherService();

  fetchData(double lat, double lon) async {
    var data = await service.fetchData(lat, lon);
    if (data is Weather) {
      Pref.save(weather: data, date: DateTime.now());
    }
    return data;
  }
}
