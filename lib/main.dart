import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:weather_clean_architecture/presentation/ui/view_models/home_viewmodel.dart';

import 'presentation/routing/app_router.dart';
import 'application/injections/injection_container.dart' as di;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(
            GetIt.instance(),
            GeolocatorPlatform.instance,
          ),
        ),
      ],
      child: DynamicColorBuilder(
        builder: (lightColorScheme, darkColorScheme) {
          if (Platform.isAndroid) {
            return MaterialApp.router(
              title: "Weather app",
              theme: FlexThemeData.light(
                colorScheme: lightColorScheme,
                useMaterial3: true,
              ),
              darkTheme: FlexThemeData.dark(
                colorScheme: darkColorScheme,
                useMaterial3: true,
              ),
              themeMode: ThemeMode.system,
              routerConfig: _appRouter.config(),
            );
          } else {
            return MaterialApp.router(
              title: "Weather app",
              theme: FlexThemeData.light(
                scheme: FlexScheme.blueM3,
                useMaterial3: true,
              ),
              darkTheme: FlexThemeData.dark(
                scheme: FlexScheme.blueM3,
                useMaterial3: true,
              ),
              themeMode: ThemeMode.system,
              routerConfig: _appRouter.config(),
            );
          }
        },
      ),
    );
  }
}
