import 'package:weather_forecast_app/service/api/weather_service.dart';
import 'package:weather_forecast_app/service/models/weather.dart';

class WeatherRepository {
  WeatherService service = WeatherService();

  fetchData(double lat, double lon) async {
    var data = await service.fetchData(lat, lon);
    if (data is Weather) {}
    return data;
  }
}
