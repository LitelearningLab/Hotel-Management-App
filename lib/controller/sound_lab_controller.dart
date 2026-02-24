import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hotelmanagementapp/dbHelper/db_helper.dart';
import 'package:hotelmanagementapp/model/category_model.dart';
import 'package:hotelmanagementapp/model/sound_model.dart';
import 'package:hotelmanagementapp/model/word_attempt.dart';
import 'package:hotelmanagementapp/public/audio_helper.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/speech_analytics_dialog.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class SoundLabController extends GetxController {
  late SoundSubcategory soundSubcategory;
  late AudioPlayer audioPlayer;
  int? currentlyPlayingIndex;
  bool audioLoading = false;
  int? loadingIndex;
  int errorPlaying = -1;
  String selectedWord = "";
  bool isCorrect = false;
  bool isPlayingOne = false;
  bool isPlayingThree = false;
  bool isCancelled = false;
  bool isPaused = false;
  int currentIndex = 0;
  int currentRepeat = 0;
  final ScrollController scrollController = ScrollController();
  int expandedIndex = -1;
  bool isProcessing = false;
  int dialogCount = 0;
  int playingIs = -1;
  bool isPlaying = false;
  String userId = "";
  String collegeId = "";
  String batchName = "";
  int isSaving = -1;
  List<bool> isPriorityList = [];
  List<SoundPractice>? soundsPractice;
  bool isLoading = true;
  List<SoundPractice> ogSoundCategories = [];
  List<SoundPractice> beforesearchResults = [];
  List<SoundPractice> currentList = [];
  List<SoundPractice> masterList = []; // Always full original list
  List<SoundPractice> filterBaseList = []; // Base list after applying filter
  List<SoundPractice> searchBaseList = []; // Base list after applying search
  TextEditingController searchController = TextEditingController();
  String searchTerm = "";
  String selectedMenuOption = '';

  bool isFiltering = false;
  bool isSearching = false;
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
    if (kIsWeb) {
      soundsPractice = soundSubcategory.soundsPractice!;
      masterList = soundsPractice!;
      isLoading = false;
    } else {
      fetchLocalOrSave();
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

  Future<void> fetchLocalOrSave() async {
    log("🔍 fetchLocalOrSave() called | isLoading = $isLoading");

    try {
      String tableName =
          soundSubcategory.name.replaceAll(RegExp(r'[^\w]+'), '').toLowerCase();
      log("📁 Using table: $tableName");

      // 1️⃣ Fetch local DB data
      final localData = await DBHelper.getAllSoundcategories(tableName);
      log("📌 Local DB returned ${localData.length} items");

      // ----- TYPE CHECK -----
      if (localData.isNotEmpty && localData.first is! Map) {
        log("⚠️ WARNING: Local DB returned NON-MAP type: ${localData.first.runtimeType}");

        throw Exception("DB returned invalid object");
      }

      if (localData.isNotEmpty) {
        // Convert local maps to model
        soundsPractice = localData.map((e) {
          log("🟦 Converting local row: $e");
          return SoundPractice.fromJson(e as Map<String, dynamic>);
        }).toList();

        isPriorityList =
            soundsPractice!.map((e) => e.downloadStatus == true).toList();
        masterList = soundsPractice!;
        isLoading = false;
        update();
        return;
      }

      // 2️⃣ No DB → insert API data
      log("💾 No local data → Saving API data to table: $tableName");

      for (var item in soundSubcategory.soundsPractice!) {
        await DBHelper.insertSoundcategory(item, tableName);
      }

      log("✅ API data inserted into DB");

      // 3️⃣ Load saved data again
      final savedData = await DBHelper.getAllSoundcategories(tableName);
      log("📌 After saving, DB returned ${savedData.length} items");

      if (savedData.isNotEmpty && savedData.first is! Map) {
        log("⚠️ WARNING: DB returned NON-MAP after save: ${savedData.first.runtimeType}");
        throw Exception("DB returned invalid object");
      }

      // Convert saved rows
      soundsPractice = savedData.map((e) {
        log("🟩 Converting saved row: $e");
        return SoundPractice.fromJson(e as Map<String, dynamic>);
      }).toList();

      isPriorityList =
          soundsPractice!.map((e) => e.downloadStatus == true).toList();
      masterList = soundsPractice!;
      isLoading = false;
      update();
      log("✅ Loaded saved data from DB");
    } catch (e, stack) {
      log("🔥 FATAL ERROR inside fetchLocalOrSave(): $e");
      log(stack.toString());
    }
  }

  void clearSearch() {
    isSearching = false;
    searchController.clear();

    soundsPractice =
        isFiltering ? List.from(filterBaseList) : List.from(masterList);
    isPriorityList =
        soundsPractice!.map((e) => e.downloadStatus == true).toList();
    update();
  }

  void applyDownloadedFilter(bool onlyDownloaded) {
    isFiltering = onlyDownloaded;

    List<SoundPractice> base = isSearching ? searchBaseList : masterList;

    filterBaseList = onlyDownloaded
        ? base.where((item) => item.downloadStatus == true).toList()
        : List.from(base);

    soundsPractice = List.from(filterBaseList);
    isPriorityList =
        soundsPractice!.map((e) => e.downloadStatus == true).toList();
    update();
  }

  void searchSubcategories(String query) {
    isSearching = query.trim().isNotEmpty;

    List<SoundPractice> base = isFiltering ? filterBaseList : masterList;

    if (isSearching) {
      searchBaseList = base
          .where(
              (item) => item.text.toLowerCase().contains(query.toLowerCase()))
          .toList();
      soundsPractice = List.from(searchBaseList);
    } else {
      soundsPractice = List.from(base);
    }

    isPriorityList =
        soundsPractice!.map((e) => e.downloadStatus == true).toList();
    update();
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

  void saveUpdate(int index) async {
    try {
      isSaving = index;
      update();

      String tableName =
          soundSubcategory.name.replaceAll(RegExp(r'[^\w]+'), '').toLowerCase();

      SoundPractice item = soundsPractice![index];

      String fileKey = item.file; // unique key
      String url = item.file;
      String fileName = item.text
          .replaceAll(' ', '_')
          .replaceAll(RegExp(r'[<>:"/\\|?*]'), '');

      // Toggle current state
      bool newValue = !isPriorityList[index];
      isPriorityList[index] = newValue;

      log("🔄 saveUpdate() | index=$index | newValue=$newValue");

      // =======================================================
      // 🔽 CASE 1: DOWNLOAD & SAVE
      // =======================================================
      if (newValue) {
        log("⬇️ Downloading + Encrypting audio for: $fileName");

        final encryptedPath =
            await AudioCryptoHelper.downloadAndEncryptAudio(url, fileName);

        log("🔐 Encrypted file saved at: $encryptedPath");

        // Update DB
        await DBHelper.updateLocalPath(fileKey, tableName, encryptedPath);
        await DBHelper.setDownloadStatus(fileKey, tableName, 1);

        // Update model
        soundsPractice![index] = item.copyWith(
          localPath: encryptedPath,
          downloadStatus: true,
        );

        log("✅ Priority Added: Path updated in DB");
      }
      // =======================================================
      // 🔼 CASE 2: REMOVE FROM PRIORITY
      // =======================================================
      else {
        log("🗑 Removing from priority: $fileName");

        final localPath = item.localPath;

        if (localPath.isNotEmpty && await File(localPath).exists()) {
          await File(localPath).delete();
          log("🗑 Local file deleted: $localPath");
        }

        // Update DB
        await DBHelper.updateLocalPath(fileKey, tableName, "");
        await DBHelper.setDownloadStatus(fileKey, tableName, 0);

        // Update model
        soundsPractice![index] = item.copyWith(
          localPath: "",
          downloadStatus: false,
        );

        log("❎ Priority Removed: DB updated");
      }

      isSaving = -1;
      update();

      Fluttertoast.showToast(
        msg: newValue
            ? "Added to your priority list"
            : "Removed from your priority list",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: linearColor,
        textColor: Colors.white,
        fontSize: 12,
      );
    } catch (e, s) {
      log("❌ ERROR in saveUpdate($index): $e");
      log(s.toString());
      isSaving = -1;
      update();
    }
  }

  Future<void> handlePlayPause(int index) async {
    loadingIndex = index;
    isPlaying = true;
    errorPlaying = -1;
    playingIs = index;
    expandedIndex = index;
    update();
    try {
      if (currentlyPlayingIndex == index) {
        await audioPlayer.pause();
        currentlyPlayingIndex = null;
      } else {
        await audioPlayer.stop();
        currentlyPlayingIndex = index;

        String? playPath;
        if (soundSubcategory.soundsPractice![index].localPath.isNotEmpty &&
            await File(soundSubcategory.soundsPractice![index].localPath)
                .exists()) {
          log("🔐 Decrypting local file before playing...");
          playPath = await AudioCryptoHelper.decryptFile(
            soundSubcategory.soundsPractice![index].localPath,
            soundSubcategory.soundsPractice![index].text
                .replaceAll(' ', '_')
                .replaceAll(RegExp(r'[<>:"/\\|?*]'), ''),
          );
          log("Decrypted to temp file: $playPath");
        } else {
          playPath = soundSubcategory.soundsPractice![index].file; // URL
          log("Playing from URL: $playPath");
        }

        await audioPlayer.setUrl(playPath);
        playingIs = -1;

        update();
        await audioPlayer.play();

        final attempt = WordAttempt(
          batch: "yourBatch",
          companyId: collegeId,
          correct: 0,
          date: "",
          lastAttempt: "",
          listAtt: 1,
          load: mianCategoryTitile,
          pracAtt: 0,
          time: 0,
          timeCal: DateTime.now().millisecondsSinceEpoch,
          title: soundSubcategory.name,
          userId: userId,
          word: soundSubcategory.soundsPractice![index].text,
        );

        await WordAttempt.saveAttempt(attempt);
      }
      errorPlaying = -1;
    } on PlayerException catch (e) {
      if (kDebugMode) {
        print(
            "❌ Audio player error: ${e.message} ${soundSubcategory.soundsPractice![index].file}");
      }
      errorPlaying = index;
      currentlyPlayingIndex = null;
    } on Exception catch (e) {
      if (kDebugMode) {
        print("❌ General audio error: $e");
      }
      errorPlaying = index;
      currentlyPlayingIndex = null;
    } finally {
      // loadingIndex = null;
      isPlaying = false;
      // expandedIndex = -1;
      update();
    }
  }

  Future<void> stopAudio() async {
    try {
      await audioPlayer.stop();
      currentlyPlayingIndex = null;
      update();
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  Future<void> stopAllPlaying() async {
    isCancelled = true;
    isPaused = false;
    isPlayingOne = false;
    isPlayingThree = false;
    currentlyPlayingIndex = null;

    try {
      await audioPlayer.stop();
    } catch (e) {
      log("Error stopping audio: $e");
    }
    await WakelockPlus.disable();

    update();
  }

  Future<void> scrollToIndex(int index) async {
    if (!scrollController.hasClients || index < 5) return;
    double offset = (index - 5) * 80.0;

    final maxScroll = scrollController.position.maxScrollExtent;
    if (offset > maxScroll) offset = maxScroll;

    await scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    update();
  }

  Future<void> resetState() async {
    isPlayingOne = false;
    isPlayingThree = false;
    isCancelled = false;
    isPaused = false;
    currentIndex = 0;
    currentRepeat = 0;
    expandedIndex = -1;
    currentlyPlayingIndex = null;

    // Smoothly scroll back to the top
    if (scrollController.hasClients) {
      await scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }

    update();
  }

  Future playOneTime() async {
    await stopAllPlaying();
    // await resetState();
    isPlayingOne = true;
    isPlayingThree = false;
    isCancelled = false;
    isPaused = false;
    currentIndex = 0;
    await WakelockPlus.enable();
    update();
    for (int i = currentIndex;
        i < soundSubcategory.soundsPractice!.length;
        i++) {
      if (isCancelled || isPlayingThree) break;
      while (isPaused) {
        await Future.delayed(const Duration(milliseconds: 200));
      }
      currentIndex = i;
      expandedIndex = i;
      update();
      await scrollToIndex(currentIndex);
      await handlePlayPause(currentIndex);
      while (currentlyPlayingIndex != null && !isCancelled) {
        if (isPaused) {
          while (isPaused && !isCancelled) {
            await Future.delayed(const Duration(milliseconds: 200));
          }
          if (isCancelled || isPlayingThree) break;
        }
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (isCancelled || isPlayingThree) break;
      await Future.delayed(const Duration(seconds: 2));
    }
    await resetState();
    await WakelockPlus.disable();
  }

  Future<void> playThreeTimes() async {
    await stopAllPlaying();
    // await resetState();
    isPlayingThree = true;
    isPlayingOne = false;
    isCancelled = false;
    isPaused = false;
    currentIndex = 0;
    currentRepeat = 0;
    await WakelockPlus.enable();
    update();
    for (int index = currentIndex;
        index < soundSubcategory.soundsPractice!.length;
        index++) {
      for (int i = currentRepeat; i < 3; i++) {
        if (isCancelled || isPlayingOne) break;
        while (isPaused) {
          await Future.delayed(const Duration(milliseconds: 200));
        }
        currentIndex = index;
        expandedIndex = index;
        currentRepeat = i;
        update();
        await scrollToIndex(currentIndex);
        await handlePlayPause(index);
        while (currentlyPlayingIndex != null && !isCancelled) {
          if (isPaused) {
            while (isPaused && !isCancelled) {
              await Future.delayed(const Duration(milliseconds: 200));
            }
            if (isCancelled || isPlayingOne) break;
          }
          await Future.delayed(const Duration(milliseconds: 100));
        }
        if (isCancelled || isPlayingOne) break;
        await Future.delayed(const Duration(seconds: 2));
      }
      currentRepeat = 0;
      if (isCancelled || isPlayingOne) break;
    }

    await resetState();
    await WakelockPlus.disable();
  }

  void pausePlaying() {
    isPaused = true;
    update();
  }

  void resumePlaying() {
    isPaused = false;
    update();
  }

  void stopPlaying() {
    isCancelled = true;
    isPaused = false;
    currentIndex = 0;
    currentRepeat = 0;
    // stopAudio(); // your stop method
    isPlayingThree = false;
    update();
  }
}
