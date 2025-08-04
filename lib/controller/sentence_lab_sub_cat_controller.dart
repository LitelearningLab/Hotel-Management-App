import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/model/sentence_model.dart';
import 'package:hotelmanagementapp/utility/result_dialog.dart';
import 'package:hotelmanagementapp/utility/speech_analytics_dialog.dart';
import 'package:just_audio/just_audio.dart';

class SentenceLabSubCatController extends GetxController {
  late String title;
  late List<SubCategoryModel> subcategories;
  int? loadingIndex = -1;
  int? currentlyPlayingIndex = -1;
  late AudioPlayer audioPlayer;
  int errorPlaying = -1;
  bool isPlaying = false;
  @override
  void onInit() {
    audioPlayer = AudioPlayer();
    final args = Get.arguments as Map<String, dynamic>?;
    title = args?['title'] ?? "";
    subcategories = args?["CategoryModel"] ?? [];
    super.onInit();
  }

  void handlePlayPause(int index, int subIndex) async {
    loadingIndex = subIndex;
    isPlaying = true;
    update();

    try {
      if (currentlyPlayingIndex == subIndex) {
        await audioPlayer.pause();
        currentlyPlayingIndex = null;
      } else {
        await audioPlayer.stop();
        currentlyPlayingIndex = subIndex;
        update();
        await audioPlayer.setUrl(subcategories[index].sentence[subIndex].file);

        await audioPlayer.play();
        currentlyPlayingIndex = null;
        update();
      }
    } catch (e) {
      print("Audio load error: $e");
      currentlyPlayingIndex = null;
      errorPlaying = subIndex;
      update();
    } finally {
      loadingIndex = null;
      isPlaying = false;
      update();
    }
  }

  void kShowDialog(String word, bool notCatch, BuildContext context) async {
    Get.dialog(Container(
      child: Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        child: SpeechAnalyticsDialog(
          false,
          isShowDidNotCatch: notCatch,
          word: word,
          title: "widget.title",
          load: "widget.load",
          main: "main",
        ),
      ),
    )).then((value) {
      if (value != null && value.isCorrect == "true" ||
          value.isCorrect == "false") {
        showDialog(
          context: context,
          builder: (BuildContext buildContext) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              child: SentenceResultDialog(
                correctedWidget: value.formatedWords,
                score: value.wordPer,
                word: word,
                isCorrect: value.isCorrect == "true" ? true : false,
                practiceType: 'Sentence Construction Lab Report',
              ),
            );
          },
        );
      } else if (value != null && value.isCorrect == "notCatch") {
        kShowDialog(word, true, context);
      } else if (value != null && value.isCorrect == "openDialog") {
        kShowDialog(word, false, context);
      }
    });
  }
}
