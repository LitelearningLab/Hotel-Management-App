import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_route.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:hotelmanagementapp/route/auth_middleware.dart';
import 'package:hotelmanagementapp/route/binding.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/in_aapp_web.dart';
import 'package:hotelmanagementapp/view/ar_simulation.dart';
import 'package:hotelmanagementapp/view/content_lab.dart';
import 'package:hotelmanagementapp/view/font_office.dart';
import 'package:hotelmanagementapp/view/home.dart';
import 'package:hotelmanagementapp/view/language_lab.dart';
import 'package:hotelmanagementapp/view/login.dart';
import 'package:hotelmanagementapp/view/no_internet_page.dart';
import 'package:hotelmanagementapp/view/prnouniciation_lab_sub.dart';
import 'package:hotelmanagementapp/view/pronounciation_lab.dart';
import 'package:hotelmanagementapp/view/search_screen.dart';
import 'package:hotelmanagementapp/view/sentence_lab.dart';
import 'package:hotelmanagementapp/view/sentence_lab_sub.dart';
import 'package:hotelmanagementapp/view/sentence_lab_sub_cat.dart';
import 'package:hotelmanagementapp/view/simulation_sub.dart';
import 'package:hotelmanagementapp/view/sound_lab.dart';
import 'package:hotelmanagementapp/view/sound_page.dart';
import 'package:hotelmanagementapp/view/splash.dart';

import '../view/grammer_lab.dart';

class RouteService {
  static List<GetPage<dynamic>>? getPages = kIsWeb
      ? [
          GetPage(
            name: AppRoutes.splashScreen,
            page: () => SplashScreen(),
            binding: SplashScreenBinding(),
          ),
          GetPage(
              name: AppRoutes.home,
              page: () => const Home(),
              binding: InitialBinding(),
              middlewares: [AuthMiddleware()]),
          GetPage(
            name: AppRoutes.login,
            page: () => LoginPage(),
            preventDuplicates: true,
          ),
          GetPage(
              name: AppRoutes.frontOffice,
              page: () => const FrontOfficeHotelReception(),
              binding: FrontOfficeBinding(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: AppRoutes.simulation,
              page: () => ARCallSimulation(),
              binding: SimulationBinding(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: AppRoutes.simulationSub,
              page: () => SimulationSub(),
              binding: SimulationSubBinding(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: AppRoutes.languageLab,
              page: () => Languagelab(),
              binding: LanguageLabBinding(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: AppRoutes.pronunciationLab,
              page: () => PronounciationLab(),
              binding: PronunciationLabBinding(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: AppRoutes.sentenceLab,
              page: () => SentenceLab(),
              binding: SentenceLabBinding(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: AppRoutes.pronunciationLabSub,
              page: () => PronunciationLabSub(),
              binding: PronunciationLabSubBinding(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: AppRoutes.grmmaerLab,
              page: () => GrammerLab(),
              binding: GrammerLabBinding(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: AppRoutes.soundPage,
              page: () => SoundPage(),
              binding: SoundPageBinding(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: AppRoutes.soundLab,
              page: () => SoundLab(),
              binding: SoundLabBinding(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: AppRoutes.sentenceLabSub,
              page: () => SentenceLabSub(),
              binding: SentenceLabSubBinding(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: AppRoutes.sentenceLabSubCat,
              page: () => SentenceLabSubCat(),
              binding: SentenceLabSubCatBinding(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: AppRoutes.searchScreen,
              page: () => SearchScreen(),
              binding: SearchScreenBinding(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: AppRoutes.contentLibrary,
              page: () => ContentLab(),
              binding: ContentLabBinding(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: AppRoutes.noInternet,
              page: () => NoInternetPage(),
              binding: NoInternetBinding(),
              middlewares: [AuthMiddleware()]),
          GetPage(
              name: AppRoutes.inAppWebView,
              page: () => InAppWebViewPage(),
              binding: InAppWebViewBinding(),
              middlewares: [AuthMiddleware()]),
        ]
      : [
          GetPage(
            name: AppRoutes.splashScreen,
            page: () => SplashScreen(),
            binding: SplashScreenBinding(),
          ),
          GetPage(
            name: AppRoutes.home,
            page: () => const Home(),
            binding: InitialBinding(),
            // middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: AppRoutes.login,
            page: () => LoginPage(),
            preventDuplicates: true,
          ),
          GetPage(
            name: AppRoutes.frontOffice,
            page: () => const FrontOfficeHotelReception(),
            binding: FrontOfficeBinding(),
            // middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: AppRoutes.simulation,
            page: () => ARCallSimulation(),
            binding: SimulationBinding(),
            // middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: AppRoutes.simulationSub,
            page: () => SimulationSub(),
            binding: SimulationSubBinding(),
            // middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: AppRoutes.languageLab,
            page: () => Languagelab(),
            binding: LanguageLabBinding(),
            // middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: AppRoutes.pronunciationLab,
            page: () => PronounciationLab(),
            binding: PronunciationLabBinding(),
            // middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: AppRoutes.sentenceLab,
            page: () => SentenceLab(),
            binding: SentenceLabBinding(),
            // middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: AppRoutes.pronunciationLabSub,
            page: () => PronunciationLabSub(),
            binding: PronunciationLabSubBinding(),
            // middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: AppRoutes.grmmaerLab,
            page: () => GrammerLab(),
            binding: GrammerLabBinding(),
            // middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: AppRoutes.soundPage,
            page: () => SoundPage(),
            binding: SoundPageBinding(),
            // middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: AppRoutes.soundLab,
            page: () => SoundLab(),
            binding: SoundLabBinding(),
            // middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: AppRoutes.sentenceLabSub,
            page: () => SentenceLabSub(),
            binding: SentenceLabSubBinding(),
            // middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: AppRoutes.sentenceLabSubCat,
            page: () => SentenceLabSubCat(),
            binding: SentenceLabSubCatBinding(),
            // middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: AppRoutes.searchScreen,
            page: () => SearchScreen(),
            binding: SearchScreenBinding(),
            // middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: AppRoutes.contentLibrary,
            page: () => ContentLab(),
            binding: ContentLabBinding(),
            // middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: AppRoutes.noInternet,
            page: () => NoInternetPage(),
            binding: NoInternetBinding(),
            // middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: AppRoutes.inAppWebView,
            page: () => InAppWebViewPage(),
            binding: InAppWebViewBinding(),
            // middlewares: [AuthMiddleware()],
          ),
        ];
}
