import 'dart:async';
import 'dart:io';

import 'package:weather_forecast_app/service/api/dio_config.dart' as dio_config;
import 'package:dio/dio.dart';
import 'package:weather_forecast_app/service/models/app_exception.dart';
import 'package:weather_forecast_app/service/models/weather.dart';

class WeatherService {
  fetchData(double lat, double lon) async {
    
    try {
      var dio = await dio_config.dio();
      var response = await dio!.get(
        "/onecall",
        queryParameters: {
          "lat": lat,
          "lon": lon,
        },
      );
      return Weather.fromJson(response.data);
    } on DioError catch (e) {
      return _exception(e);
    }
  }

  _exception(DioError e) {
    if (e.error is SocketException) {
      return NoConnectionException(e.message);
    } else if (e.error is TimeoutException) {
      return TimeOutException(e.message);
    }
    return BadRequestException(e.message);
  }
}
