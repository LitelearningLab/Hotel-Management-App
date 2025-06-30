import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_route.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:hotelmanagementapp/route/binding.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/view/ar_simulation.dart';
import 'package:hotelmanagementapp/view/font_office.dart';
import 'package:hotelmanagementapp/view/home.dart';
import 'package:hotelmanagementapp/view/language_lab.dart';
import 'package:hotelmanagementapp/view/prnouniciation_lab_sub.dart';
import 'package:hotelmanagementapp/view/pronounciation_lab.dart';
import 'package:hotelmanagementapp/view/sentence_lab.dart';
import 'package:hotelmanagementapp/view/sentence_lab_sub.dart';
import 'package:hotelmanagementapp/view/sentence_lab_sub_cat.dart';
import 'package:hotelmanagementapp/view/simulation_sub.dart';
import 'package:hotelmanagementapp/view/sound_lab.dart';
import 'package:hotelmanagementapp/view/sound_page.dart';

import '../view/grammer_lab.dart';

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
        binding: FrontOfficeBinding()),
    GetPage(
        name: AppRoutes.simulation,
        page: () => ARCallSimulation(),
        binding: SimulationBinding()),
    GetPage(
        name: AppRoutes.simulationSub,
        page: () => SimulationSub(),
        binding: SimulationSubBinding()),
    GetPage(
        name: AppRoutes.languageLab,
        page: () => Languagelab(),
        binding: LanguageLabBinding()),
    GetPage(
      name: AppRoutes.pronunciationLab,
      page: () => PronounciationLab(),
      binding: PronunciationLabBinding(),
    ),
    GetPage(
      name: AppRoutes.sentenceLab,
      page: () => SentenceLab(),
      binding: SentenceLabBinding(),
    ),
    GetPage(
      name: AppRoutes.pronunciationLabSub,
      page: () => PronunciationLabSub(),
      binding: PronunciationLabSubBinding(),
    ),
    GetPage(
      name: AppRoutes.grmmaerLab,
      page: () => GrammerLab(),
      binding: GrammerLabBinding(),
    ),
    GetPage(
      name: AppRoutes.soundPage,
      page: () => SoundPage(),
      binding: SoundPageBinding(),
    ),
    GetPage(
      name: AppRoutes.soundLab,
      page: () => SoundLab(),
      binding: SoundLabBinding(),
    ),
    GetPage(
      name: AppRoutes.sentenceLabSub,
      page: () => SentenceLabSubCat(),
      binding: SentenceLabSubCatBinding(),
    )
  ];
}
