import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
// import 'package:location/location.dart';
import 'package:weather_forecast_app/ui/children_page/cubit/weather_cubit.dart';
import 'package:weather_forecast_app/ui/main_page/cubit/main_cubit.dart';
import 'package:weather_forecast_app/ui/widgets/hourly_item.dart';
import 'package:timeago/timeago.dart' as timeago;

class DashboardPage extends StatefulWidget {
  final Position locationData;
  const DashboardPage({Key? key, required this.locationData}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
                        cubit.refreshData(widget.locationData.longitude,
                            widget.locationData.latitude);
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
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.circle,
                color: Colors.yellow,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                "Updated ${timeago.format(state.updatedAt!)}",
                style: const TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                mainWeatherImage(
                    "https://openweathermap.org/img/wn/${state.weatherData!.current!.weather!.icon}@4x.png"),
                Text("${state.weatherData!.current!.temp!.toString()}°",
                    style: const TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text(
                    state.weatherData!.current!.weather!.description!
                        .capitalizeFirstofEach,
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text(
                    "${checkDayTop(state.updatedAt!)}, ${DateFormat("dd MMMM yyyy").format(state.updatedAt ?? DateTime.now())}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.white)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const FaIcon(FontAwesomeIcons.wind, color: Colors.white),
                    const SizedBox(height: 4),
                    Text("${state.weatherData!.current!.windSpeed}kmph",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const Text("Wind Speed", style:  TextStyle(color: Colors.white))
                  ],
                ),
                Column(
                  children:  [
                    const FaIcon(FontAwesomeIcons.droplet, color: Colors.white),
                    const SizedBox(height: 4),
                    Text("${state.weatherData!.current!.humidity}%",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const Text("Humidity", style: TextStyle(color: Colors.white))
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
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                checkDayBottom(state.updatedAt!),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              InkWell(
                onTap: () {
                  context.read<MainCubit>().changePage(1);
                },
                child: Row(
                  children: [
                    Text(
                      "7 Days",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 12, color: Colors.white.withOpacity(0.7)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: state.weatherData!.hourly!
                .where((element) =>
                    DateTime.now().day ==
                    DateTime.fromMillisecondsSinceEpoch(element.dt! * 1000).day)
                .map((e) => HourlyItem(
                      selected: DateTime.now().hour ==
                          DateTime.fromMillisecondsSinceEpoch(e.dt! * 1000)
                              .hour,
                      data: e,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget mainWeatherImage(String url) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 300,
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
    } else if (date.day == today.day - 1) {
      return "Yesterday";
    } else {
      return DateFormat("EEEE").format(date);
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

extension CapExtension on String {
  String get capitalize {
    List<String> x = split("");
    x.first = x.first.toUpperCase();
    return x.join();
  }

  String get capitalizeFirstofEach =>
      split(" ").map((str) => str.capitalize).join(" ");
}
