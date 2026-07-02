import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hotelmanagementapp/model/sentence_attempt.dart';
import 'package:hotelmanagementapp/model/sentence_model.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/audio_helper.dart';
import 'package:hotelmanagementapp/dbHelper/sentence_db_helper.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/result_dialog.dart';
import 'package:hotelmanagementapp/utility/speech_analytics_dialog.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AudioStatus { idle, loading, playing, error }

enum DownloadStatus { idle, loading, success, error }

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
  Map<String, bool> isLoadingMapPlay = {};
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
  String? currentKey;
  Map<String, AudioStatus> audioStatusMap = {};
  int _playbackRequestId = 0;

  Map<String, DownloadStatus> downloadStatusMap = {};

  int _parseSafeIndex(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  late String subCategoryTitle;
  late String mainCategoryTitle;
  late int timestampIndex;
  late String activityName;
  late String sessionName;

  @override
  void onInit() {
    audioPlayer = AudioPlayer();
    final args = Get.arguments;
    final box = GetStorage();
    if (args != null) {
      title = args?['title'] ?? "";
    } else {
      final saved = box.read(AppRoutes.sentenceLabSubCat) ?? {};
      title = saved['title'] ?? "";
    }
    final ssaved = box.read(AppRoutes.sentenceLabSub) ?? {};
    subCategoryTitle = ssaved['subCategoryTitle'] ?? "";
    mainCategoryTitle = ssaved['mainCategoryTitle'] ?? "";
    timestampIndex = _parseSafeIndex(ssaved['index']);
    activityName = "";
    sessionName = title;

    activityName = "";
    sessionName = title;
    audioPlayer.playerStateStream.listen((state) async {
      if (state.processingState == ProcessingState.completed ||
          state.processingState == ProcessingState.idle) {
        if (currentKey != null) {
          audioStatusMap[currentKey!] = AudioStatus.idle;
          update();
          currentKey = null;
        }
      }

      // Optional: handle player stopped manually
      if (state.playing == false &&
          state.processingState == ProcessingState.ready) {
        if (currentKey != null) {
          audioStatusMap[currentKey!] = AudioStatus.idle;
          update();
        }
      }
    });

    _initIds();
    reloadFromDB(title);
    super.onInit();
  }

  Future<void> _initIds() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId") ?? "";
    collegeId = prefs.getString("collegeId") ?? "";
    batchName = prefs.getString("batchName") ?? "";
    update();
  }

  Future<void> reloadFromDB(String categoryName) async {
    if (!kIsWeb) {
      allSubcategories =
          await SentenceDBHelper().getSubCategoriesByCategoryName(categoryName);
      subcategories = List.from(allSubcategories);
    } else {
      final args = Get.arguments as Map<String, dynamic>?;
      final box = GetStorage();

      if (args == null) {
        final saved = box.read(AppRoutes.sentenceLabSubCat) ?? {};
        final rawList = saved['CategoryModel'];

        if (rawList is List) {
          subcategories = rawList.map((item) {
            if (item is SubCategoryModel) return item;
            if (item is Map<String, dynamic>) {
              return SubCategoryModel.fromJson(item);
            }
            throw Exception("Invalid item type in CategoryModel list");
          }).toList();
        } else {
          subcategories = [];
        }
      } else {
        final rawList = args["CategoryModel"];

        if (rawList is List) {
          subcategories = rawList.map((item) {
            if (item is SubCategoryModel) return item;
            if (item is Map<String, dynamic>) {
              return SubCategoryModel.fromJson(item);
            }
            throw Exception("Invalid item type passed in arguments");
          }).toList();
        } else {
          subcategories = [];
        }
      }
      allSubcategories = List.from(subcategories);
    }
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

  Future<void> saveUpdate(int index, int subIndex) async {
    final key = "$index-$subIndex";
    downloadStatusMap[key] = DownloadStatus.loading;
    update();

    final sentence = subcategories[index].sentence[subIndex];

    try {
      if (sentence.isDownloaded && (sentence.localPath?.isNotEmpty ?? false)) {
        final file = File(sentence.localPath!);
        if (await file.exists()) {
          await file.delete();
          log("🗑 Deleted local file: ${sentence.localPath}");
        }

        await SentenceDBHelper().updateSentenceDownloadStatusAndPath(
          sentence.id ?? 0,
          false,
          '',
        );

        sentence.isDownloaded = false;
        sentence.localPath = '';

        Fluttertoast.showToast(
          msg: "Removed from your priority list",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: linearColor,
          textColor: Colors.white,
          fontSize: 12.0,
        );
      } else {
        final encryptedPath = await AudioCryptoHelper.downloadAndEncryptAudio(
          sentence.file,
          sentence.text
              .replaceAll(' ', '_')
              .replaceAll(RegExp(r'[<>:"/\\|?*]'), ''),
        );

        await SentenceDBHelper().updateSentenceDownloadStatusAndPath(
          sentence.id ?? 0,
          true,
          encryptedPath,
        );

        sentence.isDownloaded = true;
        sentence.localPath = encryptedPath;

        Fluttertoast.showToast(
          msg: "Added to your priority list",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: linearColor,
          textColor: Colors.white,
          fontSize: 12.0,
        );
      }

      downloadStatusMap[key] = DownloadStatus.success;
    } catch (e) {
      log("❌ Download error: $e");
      downloadStatusMap[key] = DownloadStatus.error;

      Fluttertoast.showToast(
        msg: "Download failed. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
    }

    update();
  }

  // track currently playing audio

  bool _isRemoteUrl(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  bool _isFileUri(String path) {
    return path.startsWith('file://');
  }

  /// Dispose the current player, create a fresh one, and re-attach the
  /// stream listener. This guarantees the web HTML5 audio element is fully
  /// replaced — the only reliable way to switch sources in release builds.
  Future<void> _resetAudioPlayer() async {
    try {
      if (audioPlayer.playing) {
        await audioPlayer.stop();
      }
      await audioPlayer.dispose();
    } catch (_) {}

    audioPlayer = AudioPlayer();
    _attachPlayerListener();
  }

  /// Attach the completion listener to the current audioPlayer instance.
  void _attachPlayerListener() {
    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (currentKey != null) {
          audioStatusMap[currentKey!] = AudioStatus.idle;
          currentKey = null;
          update();
        }
      }
    });
  }

  void handlePlayPause(int index, int subIndex) async {
    final requestId = ++_playbackRequestId;
    final newKey = "$index-$subIndex";

    // If tapped same item — toggle pause/resume
    if (currentKey == newKey) {
      if (audioPlayer.playing) {
        await audioPlayer.pause();
        audioStatusMap[newKey] = AudioStatus.idle;
      } else {
        if (audioStatusMap[newKey] == AudioStatus.loading) return;
        audioStatusMap[newKey] = AudioStatus.loading;
        update();

        try {
          if (requestId != _playbackRequestId) return;
          await audioPlayer.play();
          if (requestId != _playbackRequestId) return;
          audioStatusMap[newKey] = AudioStatus.playing;
        } catch (e) {
          if (requestId != _playbackRequestId) return;
          audioStatusMap[newKey] = AudioStatus.error;
        }
      }
      update();
      return;
    }

    // ── Switching to a different audio ──
    // Mark old key idle
    if (currentKey != null) {
      audioStatusMap[currentKey!] = AudioStatus.idle;
    }
    currentKey = null;
    update();

    // Dispose + recreate the player so the web audio element is fully reset.
    // This fixes the release-mode bug where stop()+setUrl() still plays the
    // previously loaded source.
    await _resetAudioPlayer();
    if (requestId != _playbackRequestId) return;

    // Set loading state for new audio
    currentKey = newKey;
    audioStatusMap[newKey] = AudioStatus.loading;
    update();

    try {
      final sentence = subcategories[index].sentence[subIndex];
      String? filePathToPlay;

      if (!kIsWeb &&
          sentence.localPath != null &&
          sentence.localPath!.isNotEmpty) {
        final localFile = File(sentence.localPath!);
        if (await localFile.exists()) {
          final outputName =
              sentence.localPath!.split('/').last.split('.enc').first;
          filePathToPlay = await AudioCryptoHelper.decryptFile(
            sentence.localPath!,
            outputName,
          );
        }
      }

      filePathToPlay ??= sentence.file;
      if (kDebugMode) {
        print("$filePathToPlay attempting to play this file");
      }
      if (requestId != _playbackRequestId) return;

      // Set the audio source
      if (_isRemoteUrl(filePathToPlay) || _isFileUri(filePathToPlay)) {
        await audioPlayer.setUrl(filePathToPlay);
      } else {
        await audioPlayer.setFilePath(filePathToPlay);
      }
      if (requestId != _playbackRequestId) return;

      // Ensure we start from the beginning
      await audioPlayer.seek(Duration.zero);
      if (requestId != _playbackRequestId) return;

      audioStatusMap[newKey] = AudioStatus.playing;
      update();
      await audioPlayer.play();

      // ✅ Mark as playing here

      print("▶️ Playing: $filePathToPlay");

      // ✅ Log listening attempt
      final attempt = SentenceAttempt(
        batch: batchName,
        companyId: collegeId,
        correct: 0,
        dateTime: DateTime.now().toString(),
        focusWord: [],
        lastAttempt: DateTime.now().toString(),
        lastScore: 0,
        listAtt: 1,
        load: title,
        main: subcategories[index].id,
        pracAtt: 0,
        score: 0,
        sentence: sentence.text,
        time: 1,
        timeCal: DateTime.now().millisecondsSinceEpoch,
        title: title,
        userId: userId,
      );
      await SentenceAttempt.saveAttempt(attempt);
    } catch (e) {
      if (requestId != _playbackRequestId) return;
      log("❌ Audio load error: $e");
      audioStatusMap[newKey] = AudioStatus.error;
      update();
      currentKey = null;
    }
  }

  Widget buildAudioIcon(int index, int subIndex) {
    final key = "$index-$subIndex";
    final status = audioStatusMap[key] ?? AudioStatus.idle;

    switch (status) {
      case AudioStatus.loading:
        return SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2, color: linearColor),
        );
      case AudioStatus.playing:
        return Icon(Icons.pause_circle_outline, color: Colors.black);
      case AudioStatus.error:
        return const Icon(Icons.error, color: Colors.red);
      case AudioStatus.idle:
      default:
        return const Icon(Icons.play_circle_outline, color: Colors.black);
    }
  }

  Widget buildDownloadIcon(int index, int subIndex) {
    final key = "$index-$subIndex";
    final status = downloadStatusMap[key] ?? DownloadStatus.idle;
    final sentence = subcategories[index].sentence[subIndex];

    switch (status) {
      case DownloadStatus.loading:
        return SizedBox(
          height: 19,
          width: 19,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: linearColor,
          ),
        );
      case DownloadStatus.error:
        return const Icon(Icons.error, color: Colors.red, size: 19);
      case DownloadStatus.success:
      case DownloadStatus.idle:
      default:
        return Image.asset(
          AllAssets.save,
          width: 18,
          color: sentence.isDownloaded ? linearColor : Colors.black,
        );
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
        subCategoryTitle = main; // Set global subCategoryTitle
        final attempt = SentenceAttempt(
          batch: batchName,
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
          load: title,
          main: main, // subname (e.g. Airport)
          pracAtt: 1,
          score: value.wordPer,
          sentence: word,
          time: 1,
          timeCal: DateTime.now().millisecondsSinceEpoch,
          title: title, // Category title (e.g. Sentence Construction Lab)
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

  @override
  void onClose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    super.onClose();
  }
}
