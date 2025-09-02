import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/model/sentence_attempt.dart';
import 'package:hotelmanagementapp/model/sentence_model.dart';
import 'package:hotelmanagementapp/public/audio_helper.dart';
import 'package:hotelmanagementapp/dbHelper/sentence_db_helper.dart';
import 'package:hotelmanagementapp/utility/result_dialog.dart';
import 'package:hotelmanagementapp/utility/speech_analytics_dialog.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  String searchTerm = "";
  String selectedMenuOption = '';
  List<SubCategoryModel> allSubcategories = [];
  String searchQuery = "";
  String selectedFilter = "";
  String userId = "";
  String collegeId = "";
  String batchName = "";

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
    allSubcategories =
        await SentenceDBHelper().getSubCategoriesByCategoryName(categoryName);
    subcategories = List.from(allSubcategories);
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId") ?? "";
    collegeId = prefs.getString("collegeId") ?? "";
    batchName = prefs.getString("batchName") ?? "";
    isLoading = false;
    update();
  }

  void applySearchAndFilter() {
    List<SubCategoryModel> baseList = List.from(allSubcategories);

    // Start from filtered data if filter is active
    if (selectedFilter.isNotEmpty) {
      bool onlyDownloaded = selectedFilter == "downloaded";
      baseList = baseList
          .map((subCat) {
            final filteredSentences = subCat.sentence
                .where((sentence) => sentence.isDownloaded == onlyDownloaded)
                .toList();

            if (filteredSentences.isNotEmpty) {
              return SubCategoryModel(
                id: subCat.id,
                sentence: filteredSentences,
              );
            }
            return null;
          })
          .whereType<SubCategoryModel>()
          .toList();
    }

    // Apply search if searchTerm is not empty
    if (searchTerm.isNotEmpty) {
      final term = searchTerm.toLowerCase();
      baseList = baseList
          .map((subCat) {
            final matchingSentences = subCat.sentence
                .where((sentence) =>
                    sentence.text.toLowerCase().contains(term) ||
                    subCat.id.toLowerCase().contains(term))
                .toList();

            if (matchingSentences.isNotEmpty) {
              return SubCategoryModel(
                  id: subCat.id, sentence: matchingSentences);
            }
            return null;
          })
          .whereType<SubCategoryModel>()
          .toList();
    }

    subcategories = baseList;
    update();
  }

  void searchSentences(String query) {
    searchTerm = query.trim();
    applySearchAndFilter();
  }

  void filterByDownloadStatus(String filterType) {
    selectedFilter = filterType;
    applySearchAndFilter();
  }

  void clearSearch() {
    searchTerm = "";
    searchController.clear();
    isSearching = false;
    applySearchAndFilter();
  }

  void clearFilter() {
    selectedFilter = "";
    applySearchAndFilter(); // still applies search if active
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
        final attempt = SentenceAttempt(
          batch: "Your-Batch",
          companyId: collegeId,
          correct: 0,
          dateTime: DateTime.now().toString(),
          focusWord: [],
          lastAttempt: DateTime.now().toString(),
          lastScore: 0,
          listAtt: 1,
          load: "",
          main: title,
          pracAtt: 0,
          score: 0,
          sentence: sentence.text,
          time: 1,
          timeCal: DateTime.now().millisecondsSinceEpoch,
          title: title,
          userId: userId,
        );
        await SentenceAttempt.saveAttempt(attempt);
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

  void kShowDialog(
      String main, String word, bool notCatch, BuildContext context) async {
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
    ).then((value) async {
      if (value != null &&
          (value.isCorrect == "true" || value.isCorrect == "false")) {
        final attempt = SentenceAttempt(
          batch: "Your-Batch",
          companyId: collegeId,
          correct: value.isCorrect == "true" ? 1 : 0,
          dateTime: DateTime.now().toString(),
          focusWord: [
            {
              DateTime.now().toIso8601String(): value.correctWords ?? [],
            }
          ],
          lastAttempt: DateTime.now().toString(),
          lastScore: value.wordPer,
          listAtt: 0,
          load: main,
          main: title,
          pracAtt: 1,
          score: value.wordPer,
          sentence: word,
          time: 1,
          timeCal: DateTime.now().millisecondsSinceEpoch,
          title: title,
          userId: userId,
        );

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

        await SentenceAttempt.saveAttempt(attempt);
      } else if (value != null && value.isCorrect == "notCatch") {
        kShowDialog(main, word, true, context);
      } else if (value != null && value.isCorrect == "openDialog") {
        kShowDialog(main, word, false, context);
      }
    });
  }
}
