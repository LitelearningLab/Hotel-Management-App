import 'package:get/get.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';

class HomeController extends GetxController {
  List<String> cardNames = [
    "Accommodation\nManagement - Front Office",
    "Food & Beverage Service\nManagement",
    "Food Production",
    "Accommodation\nManagement - Housekeeping"
  ];
  List<String> cardImages = [
    AllAssets.frontOffice,
    AllAssets.foodAndBevarage,
    AllAssets.foodProduction,
    AllAssets.houseKeeping
  ];
  List<String> smartShorts = [
    "Interactive Simulations",
    "Language Lab",
    "Content Library"
  ];
}
