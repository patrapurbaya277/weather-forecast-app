import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:weather_forecast_app/ui/cubit/weather_cubit.dart';
import 'package:weather_forecast_app/ui/widgets/hourly_item.dart';
import 'package:timeago/timeago.dart' as timeago;

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final Location _location = Location();
  LocationData? _locationData;
  PermissionStatus? _permissionGranted;

  @override
  void initState() {
    initLocation();
    super.initState();
  }

  initLocation() async {
    bool _serviceEnabled;
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.deniedForever) {
      _alert();
    } else if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        SystemNavigator.pop();
      }
    } else {
      _locationData = await _location.getLocation();
      setState(() {});
    }
  }

  _alert() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Warning"),
        content: const Text(
            "Please grant access location manually from your app settings"),
        actions: [
          TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text("Cancel")),
          TextButton(onPressed: () {}, child: const Text("Settings"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff000918),
        body: _locationData == null
            ? Center(
                child: Image.asset(
                  "assets/images/appIcon.png",
                  height: 200,
                  width: 200,
                ),
              )
            : BlocProvider<WeatherCubit>(
                create: (context) => WeatherCubit()
                  ..fetchData(
                      _locationData!.longitude!, _locationData!.latitude!),
                child: BlocConsumer<WeatherCubit, WeatherState>(
                  listener: (context, state) async {
                    if (state.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.errorMessage!)));
                    }
                  },
                  builder: (context, state) {
                    final cubit = context.read<WeatherCubit>();
                    if (state.loading && state.weatherData == null) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      );
                    } else if (state.errorMessage != null &&
                        state.weatherData == null) {
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
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                initLocation();
                                cubit.refreshData(_locationData!.longitude!,
                                    _locationData!.latitude!);
                              },
                              child: const Icon(Icons.refresh,
                                  color: Colors.lightBlue),
                            ),
                          ],
                        )),
                      );
                    }
                    return SingleChildScrollView(
                      child: Stack(
                        children: [
                          Column(
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
                                      // width: MediaQuery.of(context).size.width - 40,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          bottom: Radius.circular(50),
                                        ),
                                        color: const Color(0xff82DAF4)
                                            .withOpacity(0.6),
                                      ),
                                    ),
                                    Container(
                                      // width: MediaQuery.of(context).size.width,
                                      // height: MediaQuery.of(context).size.height * 0.75,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.white.withOpacity(0.3),
                                            blurRadius: 10.0,
                                            spreadRadius: 4.0,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                        borderRadius:
                                            const BorderRadius.vertical(
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
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : SizedBox(),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget mainWidget(WeatherCubit cubit, WeatherState state) {
    return Column(
      children: [
        topWidget(state.weatherData!.timezone!, cubit),
        const SizedBox(height: 16),
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
                Text(state.weatherData!.current!.weather!.main!,
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text(
                    "Today, ${DateFormat("dd MMMM yyyy").format(state.updatedAt ?? DateTime.now())}",
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
                  children: const [
                    FaIcon(FontAwesomeIcons.wind, color: Colors.white),
                    SizedBox(height: 4),
                    Text("12kmph",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    Text("Wind", style: TextStyle(color: Colors.white))
                  ],
                ),
                Column(
                  children: const [
                    FaIcon(FontAwesomeIcons.cloudRain, color: Colors.white),
                    SizedBox(height: 4),
                    Text("87%",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    Text("Chance of rain",
                        style: TextStyle(color: Colors.white))
                  ],
                ),
                Column(
                  children: const [
                    FaIcon(FontAwesomeIcons.droplet, color: Colors.white),
                    SizedBox(height: 4),
                    Text("23%",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    Text("Humidity", style: TextStyle(color: Colors.white))
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

  Widget topWidget(String location, WeatherCubit cubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(
            Icons.menu_rounded,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () {},
        ),
        Row(
          children: [
            // const Icon(Icons.pin_drop, color: Colors.white, size: 28),
            const FaIcon(FontAwesomeIcons.locationDot,
                color: Colors.white, size: 20),
            const SizedBox(width: 4),
            Text(
              location,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 24),
            )
          ],
        ),
        PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text("Refresh"),
              onTap: () {
                cubit.refreshData(
                    _locationData!.longitude!, _locationData!.latitude!);
              },
            ),
          ],
          icon: const Icon(
            Icons.more_vert,
            color: Colors.white,
            size: 40,
          ),
        )
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
              const Text(
                "Today",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Row(
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
              )
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 24,
            itemBuilder: (context, index) => HourlyItem(
              data: state.weatherData!.hourly![index],
            ),
            scrollDirection: Axis.horizontal,
          ),
        )
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
            width: MediaQuery.of(context).size.width / 1.25,
            height: MediaQuery.of(context).size.width / 1.875,
          ),
          Image.network(
            url,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width / 1.5,
            height: MediaQuery.of(context).size.width / 2.25,
            filterQuality: FilterQuality.high,
          ),
        ],
      ),
    );
  }
}
