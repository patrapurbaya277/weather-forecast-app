import 'dart:async';
import 'package:dio/dio.dart';

Dio? dioInstance;
String baseUrl = "https://api.openweathermap.org/data/2.5";
createInstance() async {
  var options = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: 12000,
    receiveTimeout: 12000,
    queryParameters: {
      "appid":"45865970ebbfbc127eb2a16dd7f753e7",
      "units":"metric",
      "exclude":"alerts,minutely",
    },
  );

  

  dioInstance = Dio(options);

}

Future<Dio?> dio() async {
  await createInstance();
  dioInstance!.options.baseUrl = baseUrl;
  return dioInstance;
}