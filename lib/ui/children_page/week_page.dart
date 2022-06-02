import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:weather_forecast_app/ui/children_page/cubit/weather_cubit.dart';
import 'package:weather_forecast_app/ui/children_page/dashboard_page.dart';
import 'package:weather_forecast_app/ui/widgets/daily_item.dart';

class WeekPage extends StatefulWidget {
  final LocationData locationData;
  const WeekPage({Key? key, required this.locationData}) : super(key: key);

  @override
  State<WeekPage> createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff000918),
        body: BlocConsumer<WeatherCubit, WeatherState>(
          listener: (context, state) async {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                state.errorMessage!,
                style: const TextStyle(color: Colors.white),
              )));
            }
          },
          builder: (context, state) {
            final cubit = context.read<WeatherCubit>();
            if (state.errorMessage != null && state.weatherData == null) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.errorMessage!,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        cubit.refreshData(widget.locationData.longitude!,
                            widget.locationData.latitude!);
                      },
                      child: const Icon(Icons.refresh, color: Colors.lightBlue),
                    ),
                  ],
                )),
              );
            }
            return Stack(
              children: [
                ListView(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(50),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 100,
                              spreadRadius: 8,
                              offset: const Offset(0, 10),
                            ),
                          ]),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(50),
                              ),
                              color: const Color(0xff82DAF4).withOpacity(0.6),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.3),
                                  blurRadius: 10.0,
                                  spreadRadius: 4.0,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(50)),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xff82DAF4),
                                  Color(0xff126CF4),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: mainWidget(cubit, state),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    bottomWidget(state),
                  ],
                ),
                state.loading
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        width: double.infinity,
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(child: CircularProgressIndicator()),
                      )
                    : const SizedBox(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget mainWidget(WeatherCubit cubit, WeatherState state) {
    return Column(
      children: [
        const SizedBox(height: kToolbarHeight),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    mainWeatherImage(
                        "https://openweathermap.org/img/wn/${state.weatherData!.current!.weather!.icon}@4x.png"),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            checkDayTop(DateTime.fromMillisecondsSinceEpoch(
                                state.weatherData!.daily![1].dt! * 1000)),
                            style: const TextStyle(
                                fontSize: 20,
                                // fontWeight: FontWeight.w00,
                                color: Colors.white)),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: state.weatherData!.daily![1].temp!.max!
                                  .round()
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 68,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            TextSpan(
                              text:
                                  "/${state.weatherData!.daily![1].temp!.min!.round().toString()}°",
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(0.5)),
                            ),
                          ]),
                        ),
                        Text(
                          state.weatherData!.daily![1].weather!.description!
                              .capitalizeFirstofEach,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Colors.white.withOpacity(0.5)),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const FaIcon(FontAwesomeIcons.wind, color: Colors.white),
                    const SizedBox(height: 4),
                    Text("${state.weatherData!.daily![1].windSpeed}kmph",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const Text("Wind Speed",
                        style: TextStyle(color: Colors.white))
                  ],
                ),
                Column(
                  children: [
                    const FaIcon(FontAwesomeIcons.cloudRain,
                        color: Colors.white),
                    const SizedBox(height: 4),
                    Text("${state.weatherData!.daily![1].rain}%",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const Text("Chance of rain",
                        style: TextStyle(color: Colors.white))
                  ],
                ),
                Column(
                  children: [
                    const FaIcon(FontAwesomeIcons.droplet, color: Colors.white),
                    const SizedBox(height: 4),
                    Text("${state.weatherData!.daily![1].humidity}%",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const Text("Humidity",
                        style:  TextStyle(color: Colors.white))
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget bottomWidget(WeatherState state) {
    return Column(
      children: state.weatherData!.daily!
          .map((e) => DailyItem(
                data: e,
              ))
          .toList(),
    );
  }

  Widget mainWeatherImage(String url) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 200,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            url,
            fit: BoxFit.cover,
            color: Colors.white.withOpacity(0.2),
            frameBuilder: (context, child, x, y) => SizedBox(
              width: MediaQuery.of(context).size.width / 1.25,
              height: MediaQuery.of(context).size.width / 1.875,
            ),
            width: MediaQuery.of(context).size.width / 1.25,
            height: MediaQuery.of(context).size.width / 1.875,
            errorBuilder: (context, child, stacktrace) => SizedBox(
              width: MediaQuery.of(context).size.width / 1.25,
              height: MediaQuery.of(context).size.width / 1.875,
            ),
          ),
          Image.network(
            url,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width / 1.5,
            height: MediaQuery.of(context).size.width / 2.25,
            filterQuality: FilterQuality.high,
            errorBuilder: (context, child, stacktrace) => SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.width / 2.25,
            ),
          ),
        ],
      ),
    );
  }

  String checkDayTop(DateTime date) {
    DateTime today = DateTime.now();
    if (date.day == today.day) {
      return "Today";
    } else if (date.day > today.day) {
      return "Tomorrow";
    } else {
      return DateFormat("dddd").format(date);
    }
  }

  String checkDayBottom(DateTime date) {
    DateTime today = DateTime.now();
    if (date.day == today.day) {
      return "Today";
    } else if (date.day == today.day - 1) {
      return "Yesterday";
    } else {
      return DateFormat("dd MM yyyy").format(date);
    }
  }
}
