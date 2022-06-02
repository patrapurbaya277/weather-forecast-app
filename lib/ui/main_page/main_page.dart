import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:weather_forecast_app/service/local/pref.dart';
import 'package:weather_forecast_app/ui/children_page/cubit/weather_cubit.dart';
import 'package:weather_forecast_app/ui/children_page/dashboard_page.dart';
import 'package:weather_forecast_app/ui/children_page/week_page.dart';
import 'package:weather_forecast_app/ui/main_page/cubit/main_cubit.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late FancyDrawerController _controller;
  final Location location = Location();
  LocationData? locationData;

  @override
  void initState() {
    super.initState();
    Pref.load();
    _controller = FancyDrawerController(
        vsync: this, duration: const Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });
    checkLocation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  getLocation() async {
    locationData = await location.getLocation();
  }

  checkLocation() async {
    bool enabled = await location.serviceEnabled();
    if (enabled) {
      await getLocation();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please turn on location",
              style: TextStyle(color: Colors.white))));
      bool isTurnedOn = await location.requestService();
      if (isTurnedOn) {
        await getLocation();
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainCubit>(
      create: (context) => MainCubit(),
      child: BlocBuilder<MainCubit, MainState>(builder: (context, state) {
        final mainCubit = context.read<MainCubit>();
        return SafeArea(
          child: locationData != null
              ? FancyDrawerWrapper(
                  hideOnContentTap: true,
                  cornerRadius: 40,
                  drawerItems: [
                    TextButton(
                      onPressed: () {
                        mainCubit.changePage(0);
                        _controller.close();
                      },
                      child: Text(
                        "Current",
                        style: TextStyle(
                          color: state.selectedIndex == 0
                              ? Colors.white
                              : Colors.grey,
                          fontSize: state.selectedIndex == 0 ? 24 : 20,
                          fontWeight:
                              state.selectedIndex == 1 ? FontWeight.bold : null,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        mainCubit.changePage(1);
                        _controller.close();
                      },
                      child: Text(
                        "7 Days",
                        style: TextStyle(
                          color: state.selectedIndex == 1
                              ? Colors.white
                              : Colors.grey,
                          fontSize: state.selectedIndex == 1 ? 24 : 20,
                          fontWeight:
                              state.selectedIndex == 1 ? FontWeight.bold : null,
                        ),
                      ),
                    ),
                  ],
                  controller: _controller,
                  backgroundColor: const Color(0xff000918),
                  child: BlocProvider<WeatherCubit>(
                    create: (context) => WeatherCubit()
                      ..fetchData(
                          locationData!.longitude!, locationData!.latitude!),
                    child: BlocBuilder<WeatherCubit, WeatherState>(
                        builder: (context, weatherState) {
                      final weatherCubit = context.read<WeatherCubit>();
                      if (weatherState.loading &&
                          weatherState.weatherData == null) {
                        return const Scaffold(
                          backgroundColor: Color(0xff000918),
                          body:  Center(child:  CircularProgressIndicator()),
                        );
                      }
                      return Scaffold(
                        body: RefreshIndicator(
                          onRefresh: () async {
                            await weatherCubit.refreshData(
                                locationData!.longitude!,
                                locationData!.latitude!);
                          },
                          child: Stack(
                            children: [
                              [
                                DashboardPage(
                                  locationData: locationData!,
                                ),
                                WeekPage(
                                  locationData: locationData!,
                                ),
                              ][state.selectedIndex],
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.menu_rounded,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    onPressed: _controller.open,
                                  ),
                                  Row(
                                    children: [
                                      state.selectedIndex == 0
                                          ? const FaIcon(
                                              FontAwesomeIcons.locationDot,
                                              color: Colors.white,
                                              size: 20)
                                          : const SizedBox(),
                                      const SizedBox(width: 4),
                                      Text(
                                        state.selectedIndex == 0
                                            ? weatherState
                                                .weatherData!.timezone!
                                            : "7 Days",
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
                                          weatherCubit.refreshData(
                                              locationData!.longitude!,
                                              locationData!.latitude!);
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
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                )
              : Center(
                  child: Image.asset(
                    "assets/images/appIcon.png",
                    height: 100,
                    width: 100,
                  ),
                ),
        );
      }),
    );
  }
}
