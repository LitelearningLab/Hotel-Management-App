import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hotelmanagementapp/model/sound_model.dart';

class LanguageLabController extends GetxController {
  int selectedIndex = 0;
  List<SoundModel> soundPageModel = [];
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    fetchAndPrintProfluentEnglishData();
  }

  ontapTab(int index) {
    selectedIndex = index;
    update();
  }

  Future<void> fetchAndPrintProfluentEnglishData() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final QuerySnapshot snapshot =
          await firestore.collection('ProfluentEnglish').get();

      for (var doc in snapshot.docs) {
        final data = SoundModel.fromJson(doc.data() as Map<String, dynamic>);
        soundPageModel.add(data);
      }
      soundPageModel.sort((a, b) => a.order.compareTo(b.order));
      log("sound length :- ${soundPageModel.length}");

      isLoading = false;
      update();
    } catch (e) {
      log("Error fetching data: $e");
      isLoading = false;
      update();
    }
  }
}
