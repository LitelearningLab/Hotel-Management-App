import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/model/sentence_model.dart';
import 'package:hotelmanagementapp/public/audio_helper.dart';
import 'package:hotelmanagementapp/public/sentence_db_helper.dart';
import 'package:hotelmanagementapp/utility/result_dialog.dart';
import 'package:hotelmanagementapp/utility/speech_analytics_dialog.dart';
import 'package:just_audio/just_audio.dart';

class SentenceLabSubCatController extends GetxController {
  late String title;
  late int categoryId;
  List<SubCategoryModel> subcategories = [];
  bool isLoading = false;

  int? loadingIndex = -1;
  int? currentlyPlayingIndex = -1;
  late AudioPlayer audioPlayer;
  int errorPlaying = -1;
  bool isPlaying = true;
  List<bool> isSaved = [];
  int isSaving = -1;
  Map<String, bool> isLoadingMap = {};

  @override
  void onInit() {
    audioPlayer = AudioPlayer();
    final args = Get.arguments as Map<String, dynamic>?;

    title = args?['title'] ?? "";

    // subcategories = args?["CategoryModel"] ?? [];

    reloadFromDB(title);
    super.onInit();
  }

  Future<void> reloadFromDB(String categoryName) async {
    subcategories =
        await SentenceDBHelper().getSubCategoriesByCategoryName(categoryName);
    isLoading = false;

    update();
  }

  saveUpdate(int index, int subIndex) async {
    final key = "$index-$subIndex";
    isLoadingMap[key] = true;
    update();
    final sentence = subcategories[index].sentence[subIndex];

    if (sentence.isDownloaded && (sentence.localPath?.isNotEmpty ?? false)) {
      final file = File(sentence.localPath!);
      if (await file.exists()) {
        await file.delete();
        log("Deleted local file: ${sentence.localPath}");
      }

      await SentenceDBHelper().updateSentenceDownloadStatusAndPath(
        sentence.id ?? 0,
        false,
        '',
      );

      sentence.isDownloaded = false;
      sentence.localPath = '';
    } else {
      final encryptedPath = await AudioCryptoHelper.downloadAndEncryptAudio(
        sentence.file,
        sentence.text.replaceAll(' ', '_'),
      );

      await SentenceDBHelper().updateSentenceDownloadStatusAndPath(
        sentence.id ?? 0,
        true,
        encryptedPath,
      );

      sentence.isDownloaded = true;
      sentence.localPath = encryptedPath;
    }

    isLoadingMap[key] = false;
    update();
  }

  void handlePlayPause(int index, int subIndex) async {
    loadingIndex = subIndex;
    isPlaying = true;
    update();

    try {
      final sentence = subcategories[index].sentence[subIndex];
      String? filePathToPlay;

      if (sentence.localPath != null && sentence.localPath!.isNotEmpty) {
        final localFile = File(sentence.localPath!);
        if (await localFile.exists()) {
          log("✅ Local encrypted file found. Decrypting...");
          filePathToPlay = await AudioCryptoHelper.decryptFile(
            sentence.localPath!,
            sentence.text.replaceAll(' ', '_'),
          );
          log("🎵 Playing decrypted local file: $filePathToPlay");
        }
      }

      if (filePathToPlay == null) {
        log("🌐 No local file found, streaming from network...");
        filePathToPlay = sentence.file;
      }

      if (currentlyPlayingIndex == subIndex) {
        await audioPlayer.pause();
        currentlyPlayingIndex = null;
      } else {
        await audioPlayer.stop();
        currentlyPlayingIndex = subIndex;
        update();

        await audioPlayer.setUrl(filePathToPlay);
        await audioPlayer.play();

        currentlyPlayingIndex = null;
      }
    } catch (e) {
      log("❌ Audio load error: $e");
      currentlyPlayingIndex = null;
      errorPlaying = subIndex;
    } finally {
      loadingIndex = null;
      isPlaying = false;
      update();
    }
  }

  void kShowDialog(String word, bool notCatch, BuildContext context) async {
    Get.dialog(
      Dialog(
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
    ).then((value) {
      if (value != null &&
          (value.isCorrect == "true" || value.isCorrect == "false")) {
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
                isCorrect: value.isCorrect == "true",
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
