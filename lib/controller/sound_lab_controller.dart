import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hotelmanagementapp/model/sound_model.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/speech_analytics_dialog.dart';
import 'package:just_audio/just_audio.dart';

class SoundLabController extends GetxController {
  late SoundSubcategory soundSubcategory;
  late AudioPlayer audioPlayer;
  int? currentlyPlayingIndex;
  bool audioLoading = false;
  int? loadingIndex;
  int errorPlaying = -1;
  String selectedWord = "";
  bool isCorrect = false;
  @override
  void onInit() {
    audioPlayer = AudioPlayer();
    final args = Get.arguments;
    final box = GetStorage();
    if (args != null) {
      soundSubcategory = args["soundSubcategory"];
    } else {
      final saved = box.read(AppRoutes.soundLab) ?? {};
      final storedSound = saved['soundSubcategory'];
      if (storedSound is Map<String, dynamic>) {
        soundSubcategory = SoundSubcategory.fromJson(storedSound);
      } else if (storedSound is SoundSubcategory) {
        soundSubcategory = storedSound;
      }
    }

    audioPlayer.playerStateStream.listen((state) {
      if (state.playing && state.processingState == ProcessingState.ready) {
        update();
      }
      if (state.processingState == ProcessingState.completed) {
        currentlyPlayingIndex = null;
        update();
      }
    });
    super.onInit();
  }

  void kShowDialog(String word, bool notCatch, BuildContext context) async {
    // log("message");
    Get.dialog(
      Container(
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          child: SpeechAnalyticsDialog(
            true,
            isShowDidNotCatch: notCatch,
            word: word,
            title: "widget.title",
            load: "widget.load",
          ),
        ),
      ),
    ).then((value) {
      if (value != null && value.isCorrect == "true" ||
          value.isCorrect == "false") {
        selectedWord = word;
        isCorrect = value.isCorrect == "true" ? true : false;
        log("is correct or not ${isCorrect}");
        update();
      } else if (value != null && value.isCorrect == "notCatch") {
        kShowDialog(word, true, context);
      } else if (value != null && value.isCorrect == "openDialog") {
        kShowDialog(word, false, context);
      }
    }).onError((error, stackTrace) {
      // log(error.toString());
    });
  }

  void handlePlayPause(int index) async {
    loadingIndex = index;
    update();

    try {
      if (currentlyPlayingIndex == index) {
        await audioPlayer.pause();
        currentlyPlayingIndex = null;
      } else {
        await audioPlayer.stop();
        await audioPlayer.setUrl(soundSubcategory.soundsPractice![index].file);
        await audioPlayer.playerStateStream.firstWhere(
            (state) => state.processingState == ProcessingState.ready);
        currentlyPlayingIndex = index;
        update();
        await audioPlayer.play();
      }
    } catch (e) {
      print("Audio load error: $e");
      currentlyPlayingIndex = null;
      errorPlaying = index;
      update();
    } finally {
      loadingIndex = null;
      update();
    }
  }
}
