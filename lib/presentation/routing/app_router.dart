import 'package:auto_route/auto_route.dart';
import 'package:weather_clean_architecture/presentation/ui/views/home_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, path: "/"),
      ];
}
