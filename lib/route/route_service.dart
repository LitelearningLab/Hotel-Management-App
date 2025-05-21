import 'package:get/get_navigation/src/routes/default_route.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:hotelmanagementapp/route/binding.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/view/font_office.dart';
import 'package:hotelmanagementapp/view/home.dart';

class RouteService {
  static List<GetPage<dynamic>>? getPages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const Home(),
      binding: InitialBinding(),
    ),
    GetPage(
        name: AppRoutes.frontOffice,
        page: () => const FrontOfficeHotelReception(),
        binding: FrontOfficeBinding())
  ];
}
