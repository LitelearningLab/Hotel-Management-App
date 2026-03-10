import 'package:hotelmanagementapp/public/common_function.dart';

class AppRoutes {
  static String get _normalizedPathTitle => getCurrentPathTitle();

  static String get _routeBaseSegment =>
      _normalizedPathTitle.isNotEmpty ? _normalizedPathTitle : 'guest-experience';

  static const home = '/home';
  static const frontOfficePattern = '/:pathTitle';
  static String get frontOffice => '/$_routeBaseSegment';
  static const simulation = '/simulations';
  static const simulationSub = '/simulations/details';
  static const languageLab = '/language-lab';
  static const pronunciationLab = '/language-lab/pronunciation';
  static const sentenceLab = '/language-lab/sentence';
  static const pronunciationLabSubPattern = '/:pathTitle/pronunciation/sub';
  static String get pronunciationLabSub => '/$_routeBaseSegment/pronunciation/sub';
  static const grmmaerLab = '/language-lab/grammar';
  static const soundPage = '/language-lab/sound';
  static const soundLab = '/language-lab/sound-lab';
  static const sentenceLabSub = '/language-lab/sentence/sub';
  static const searchScreen = '/search';
  static const contentLibrary = '/content-library';
  static const splashScreen = '/welcome';
  static const noInternet = '/no-internet';
  static const inAppWebView = '/browser';
  static const login = '/login';
  static const sentenceLabSubCat = '/language-lab/sentence-category';
  static const feedbackpage = '/feedback';
  static const frontOfficeStoreKey = 'front_office_page_data';
  static const pronunciationLabSubStoreKey = 'pronunciation_lab_sub_page_data';
}
