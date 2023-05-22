import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math.dart';
import 'package:weather_clean_architecture/domain/entities/weather_data.dart';
import 'package:weather_clean_architecture/presentation/ui/view_models/home_viewmodel.dart';
import 'package:weather_icons/weather_icons.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel viewModel;

  @override
  void initState() {
    viewModel = Provider.of<HomeViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.getWeather();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Consumer<HomeViewModel>(
          builder: (BuildContext context, HomeViewModel model, Widget? child) {
            if (model.hasWeather) {
              return Center(
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            model.currentWeather.icon,
                            size: 36.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                model.city.name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                model.currentWeather.description,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${model.currentWeather.temp.round()}°",
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              Row(
                                children: [
                                  Transform.rotate(
                                    angle: radians(
                                      model.currentWeather.windDeg.toDouble(),
                                    ),
                                    child: const Icon(Icons.arrow_downward),
                                  ),
                                  Text("${model.currentWeather.windSpeed} m/s"),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          ...model.hourlyForecast
                              .map(
                                (forecastData) => Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${forecastData.temp.round()}°"),
                                      Icon(
                                        forecastData.icon,
                                        size: 18.0,
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        forecastData.dateTime.hour.toString(),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: model.dailyForecast
                              .map(
                                (WeatherData day) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        DateFormat('EEEE').format(day.dateTime),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      const Spacer(),
                                      Icon(day.icon, size: 20.0),
                                      const SizedBox(width: 16.0),
                                      Text(
                                        "${day.temp.round()}°",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (model.hasError) {
              return Center(
                child: Text(model.errorMessage!),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.getWeather,
        child: const Icon(Icons.replay),
      ),
    );
  }
}
