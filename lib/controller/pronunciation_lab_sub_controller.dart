import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hotelmanagementapp/model/word_attempt.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';

import 'package:get/get.dart';

import 'package:hotelmanagementapp/model/category_model.dart';
import 'package:hotelmanagementapp/public/audio_helper.dart';
import 'package:hotelmanagementapp/dbHelper/db_helper.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/speech_analytics_dialog.dart';

import 'package:just_audio/just_audio.dart';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_core/firebase_core.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class PronunciationLabSubController extends GetxController {
  String title = "";
  List<SubcategoryPro> subcategories = [];
  List<SubcategoryPro> ogSubCategories = [];
  List<SubcategoryPro> beforesearchResults = [];
  List<SubcategoryPro> currentList = [];
  List<SubcategoryPro> masterList = []; // Always full original list
  List<SubcategoryPro> filterBaseList = []; // Base list after applying filter
  List<SubcategoryPro> searchBaseList = []; // Base list after applying search

  bool isFiltering = false;
  bool isSearching = false;

  late Category category;
  bool isLoading = true;
  String collectionName = '';
  String id = "";
  String selectedWord = "";
  bool isCorrect = false;
  late AudioPlayer audioPlayer;
  int? currentlyPlayingIndex;
  bool audioLoading = false;
  int? loadingIndex;
  List<bool> isPriorityList = [];
  int errorPlaying = -1;
  bool isPlaying = false;
  int playingIs = -1;
  int isSaving = -1;
  // bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  String searchTerm = "";
  String selectedMenuOption = '';
  String userId = "";
  String collegeId = "";
  String batchName = "";
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
  String? subTitle;
  String _sanitizeLocalPath(String path) {
    final trimmed = path.trim();
    if (trimmed.startsWith('file://')) {
      return trimmed.replaceFirst('file://', '');
    }
    return trimmed;
  }

  String _normalizeRemoteUrl(String url) {
    final trimmed = url.trim();
    final parsed = Uri.tryParse(trimmed);
    if (parsed == null) return trimmed;
    return parsed.toString();
  }

  @override
  void onInit() {
    readyFirs();
    super.onInit();
    update();
  }

  void readyFirs() async {
    audioPlayer = AudioPlayer();
    final args = Get.arguments;
    final box = GetStorage();
    var argList = [];
    if (args != null) {
      title = args['title'];
      argList = args['subcategories'] as List;
      collectionName = args['pronunCollectionName'] ?? '';
      id = args['id'] ?? "";
    } else {
      final saved = box.read(AppRoutes.pronunciationLabSub) ?? {};
      title = saved['title'] ?? "";
      final subList = saved['subcategories'] ?? [];
      argList = subList
          .map<SubcategoryPro>((e) => SubcategoryPro.fromMap(e))
          .toList();
      collectionName = saved['pronunCollectionName'] ?? '';
      id = saved['id'] ?? "";
    }
    debugPrint("collection name is $collectionName");
    debugPrint("argument list is $argList");
    debugPrint("title is $title");

    ogSubCategories = argList
        .map((item) => item is SubcategoryPro
            ? item
            : SubcategoryPro.fromMap(Map<String, dynamic>.from(item)))
        .toList();

    audioPlayer.playerStateStream.listen((state) {
      if (state.playing && state.processingState == ProcessingState.ready) {
        playingIs = -1;
        update();
      }
      if (state.processingState == ProcessingState.completed) {
        currentlyPlayingIndex = null;
        playingIs = -1;
        update();
      }
    });

    if (id == "") {
      if (!kIsWeb) {
        elseCase();
      } else {
        subcategories = ogSubCategories;
        isLoading = false;
      }

      // isPriorityList =
      //     subcategories.map((e) => e.downloadStatus == true).toList();
      // isLoading = false;
    } else {
      fetchPronunById(id);
    }
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId") ?? "";
    collegeId = prefs.getString("collegeId") ?? "";
    batchName = prefs.getString("batchName") ?? "";
    update();
  }

  void applyDownloadedFilter(bool onlyDownloaded) {
    isFiltering = onlyDownloaded;

    List<SubcategoryPro> base = isSearching ? searchBaseList : masterList;

    filterBaseList = onlyDownloaded
        ? base.where((item) => item.downloadStatus == true).toList()
        : List.from(base);

    subcategories = List.from(filterBaseList);
    isPriorityList =
        subcategories.map((e) => e.downloadStatus == true).toList();
    update();
  }

  Future<void> kShowDialog(
      String word, bool notCatch, BuildContext context) async {
    dialogCount++;
    isProcessing = true;
    update();
    log("isProcessing is true. Dialog Count: $dialogCount");

    try {
      final value = await Get.dialog(
        Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          child: SpeechAnalyticsDialog(
            true,
            isShowDidNotCatch: notCatch,
            word: word,
            title: title,
            load: mianCategoryTitile,
          ),
        ),
      );

      if (value != null) {
        final result = value.isCorrect;

        if (result == "true" || result == "false") {
          selectedWord = word;
          isCorrect = result == "true";
          log("Attempt made. Word: $word, Correct: $isCorrect");

          final attempt = WordAttempt(
            batch: "CurrentBatchId",
            companyId: collegeId,
            correct: isCorrect ? 1 : 0,
            date: DateTime.now().toIso8601String().substring(0, 10),
            lastAttempt: DateTime.now().toIso8601String(),
            listAtt: 0,
            load: mianCategoryTitile,
            pracAtt: 1,
            time: 0,
            timeCal: DateTime.now().millisecondsSinceEpoch,
            title: title,
            userId: userId,
            word: word,
          );

          await WordAttempt.saveAttempt(attempt);
          update();
        } else if (result == "notCatch") {
          await kShowDialog(word, true, context);
        } else if (result == "openDialog") {
          await kShowDialog(word, false, context);
        }
      }
    } catch (e, st) {
      log("Dialog error: $e\nStack: $st");
    } finally {
      dialogCount--;
      if (dialogCount == 0) {
        isProcessing = false;
        update();
        log("All dialogs closed. isProcessing is false.");
      } else {
        log("Dialog closed, but $dialogCount more are still active in the stack.");
      }
    }
  }

  void searchSubcategories(String query) {
    isSearching = query.trim().isNotEmpty;

    List<SubcategoryPro> base = isFiltering ? filterBaseList : masterList;

    if (isSearching) {
      searchBaseList = base
          .where(
              (item) => item.text.toLowerCase().contains(query.toLowerCase()))
          .toList();
      subcategories = List.from(searchBaseList);
    } else {
      subcategories = List.from(base);
    }

    isPriorityList =
        subcategories.map((e) => e.downloadStatus == true).toList();
    update();
  }

  void saveUpdate(int index) async {
    isSaving = index;
    String tableName = title.replaceAll(RegExp(r'[^\w]+'), '').toLowerCase();
    String fileKey = subcategories[index].file; // Use exact file key
    String fileName = subcategories[index]
        .text
        .replaceAll(' ', '_')
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '');
    String url = subcategories[index].file;

    // Toggle current UI state first
    bool newValue = !isPriorityList[index];
    isPriorityList[index] = newValue;
    subcategories[index].downloadStatus = newValue;
    for (final item in ogSubCategories) {
      if (item.file == subcategories[index].file ||
          item.text.toLowerCase() == subcategories[index].text.toLowerCase()) {
        item.downloadStatus = newValue;
      }
    }
    try {
      update();

      if (newValue) {
        log("⬇️ Downloading and encrypting for $fileName...");
        final encryptedPath =
            await AudioCryptoHelper.downloadAndEncryptAudio(url, fileName);

        // Update DB with local path and downloadStatus = true
        await DBHelper.updateLocalPath(fileKey, tableName, encryptedPath);
        await DBHelper.setDownloadStatus(fileKey, tableName, 1);

        subcategories[index] =
            subcategories[index].copyWith(localPath: encryptedPath);
        log("✅ Downloaded & saved local path: $encryptedPath");
      } else {
        final localPath = subcategories[index].localPath;
        final sanitized = _sanitizeLocalPath(localPath);
        if (sanitized.isNotEmpty && await File(sanitized).exists()) {
          await File(sanitized).delete();
          log("🗑 Deleted local file: $localPath");
        }

        // Update DB with empty localPath and downloadStatus = false
        await DBHelper.updateLocalPath(fileKey, tableName, "");
        await DBHelper.setDownloadStatus(fileKey, tableName, 0);

        subcategories[index] = subcategories[index].copyWith(localPath: "");
      }

      log("✅ isPriority updated to $newValue at index $index");
      update();
    } catch (e) {
      log("❌ Failed to update isPriority at index $index: $e");
    }
    isSaving = -1;
    Fluttertoast.showToast(
        msg: newValue
            ? "Added to your priority list"
            : "Removed from your priority list",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: linearColor,
        textColor: Colors.white,
        fontSize: 12.0);
    update();
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
    for (int i = currentIndex; i < subcategories.length; i++) {
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
    for (int index = currentIndex; index < subcategories.length; index++) {
      for (int i = currentRepeat; i < 3; i++) {
        if (isCancelled || isPlayingOne) break;
        while (isPaused) {
          await Future.delayed(const Duration(milliseconds: 200));
        }
        currentIndex = index;

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

  Future handlePlayPause(int index) async {
    log("${subcategories[index].file}");
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

        final tableName = title.replaceAll(RegExp(r'[^\w]+'), '').toLowerCase();
        if (subcategories[index].localPath.isEmpty && !kIsWeb) {
          final localData = await DBHelper.getAllSubcategoriesValidated(
            tableName,
          );
          final matched = localData
              .where(
                (e) =>
                    e.file == subcategories[index].file ||
                    e.text.toLowerCase() ==
                    subcategories[index].text.toLowerCase(),
              )
              .toList();
          if (matched.isNotEmpty && matched.first.localPath.isNotEmpty) {
            subcategories[index] = subcategories[index].copyWith(
              localPath: _sanitizeLocalPath(matched.first.localPath),
            );
          }
        }

        bool isLocalSource = false;
        late String playPath;
        final localPath = _sanitizeLocalPath(subcategories[index].localPath);
        final hasLocalFile =
            localPath.isNotEmpty && await File(localPath).exists();

        if (hasLocalFile) {

          log("🔐 Decrypting local file before playing...");
          playPath = await AudioCryptoHelper.decryptFile(
            localPath,
            subcategories[index]
                .text
                .replaceAll(' ', '_')
                .replaceAll(RegExp(r'[<>:"/\\|?*]'), ''),
          );
          isLocalSource = true;
          log("Decrypted to temp file: $playPath");
        } else {
          playPath = _normalizeRemoteUrl(subcategories[index].file);
          if (localPath.isNotEmpty && !hasLocalFile) {
            log("⚠️ Local path missing, fallback to remote URL: $localPath");
          }
          log("Playing from URL: $playPath");
        }

        if (isLocalSource) {
          await audioPlayer.setFilePath(playPath);
        } else {
          await audioPlayer.setUrl(playPath);
        }
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
          title: title,
          userId: userId,
          word: subcategories[index].text,
        );

        await WordAttempt.saveAttempt(attempt);
      }
      errorPlaying = -1;
    } on PlayerException catch (e) {
      print(
          "❌ Audio player error: ${e.message} | file=${subcategories[index].file} | localPath=${subcategories[index].localPath}");
      errorPlaying = index;
      currentlyPlayingIndex = null;
      playingIs = -1;
    } on Exception catch (e) {
      print("❌ General audio error: $e");
      errorPlaying = index;
      currentlyPlayingIndex = null;
      playingIs = -1;
    } finally {
      // loadingIndex = null;
      isPlaying = false;
      // expandedIndex = -1;
      update();
    }
  }

  String normalizePath(String path) {
    if (path.startsWith('file://')) {
      return path.replaceFirst('file://', '');
    }
    return path;
  }

  void clearFilter() {
    isFiltering = false;

    subcategories =
        isSearching ? List.from(searchBaseList) : List.from(masterList);
    isPriorityList =
        subcategories.map((e) => e.downloadStatus == true).toList();
    update();
  }

  Future<void> elseCase() async {
    final tableName = title.replaceAll(RegExp(r'[^\w]+'), '').toLowerCase();
    await DBHelper.ensureTableExists(tableName);

    // Fetch local data
    final localData = await DBHelper.getAllSubcategoriesValidated(tableName);
    log("📥 Local has ${localData.length} items, Firebase has ${ogSubCategories.length}");

    final localFiles = localData.map((e) => e.file).toSet();
    final incomingFiles = ogSubCategories.map((e) => e.file).toSet();

    // 1️⃣ Add or update items (upsert)
    for (var item in ogSubCategories) {
      final existing = localData.firstWhere((e) => e.file == item.file,
          orElse: () => SubcategoryPro(
                file: '',
                isPriority: '',
                syllables: '',
                text: '',
                pronun: '',
                downloadStatus: false,
                localPath: '',
                sentenceSamples: [],
                meaningSamples: [],
              ));

      await DBHelper.insertSubcategory(
          item.copyWith(
            localPath: existing.localPath, // Preserve localPath if exists
          ),
          tableName);

      log("✅ Upserted: ${item.file}");
    }

    // 2️⃣ Delete items removed from Firebase
    final toDelete =
        localData.where((e) => !incomingFiles.contains(e.file)).toList();
    for (var item in toDelete) {
      log("🗑️ Removing: ${item.file}");
      final db = await DBHelper.database;
      await db.delete(
        '"$tableName"',
        where: 'file = ?',
        whereArgs: [item.file],
      );
    }

    // 3️⃣ Remove any duplicates (based on `file`)
    await DBHelper.removeDuplicates(tableName);
    log("🔧 Duplicates removed, if any.");

    // 4️⃣ Reload final synced data
    subcategories = await DBHelper.getAllSubcategoriesValidated(tableName);

    // ✅ Sort alphabetically by `text`
    // subcategories
    //     .sort((a, b) => a.text.toLowerCase().compareTo(b.text.toLowerCase()));

    // Reset master + filters
    ogSubCategories = List.from(subcategories);
    masterList = List.from(ogSubCategories);
    filterBaseList = List.from(masterList);
    searchBaseList = List.from(masterList);

    isPriorityList =
        subcategories.map((e) => e.downloadStatus == true).toList();

    isLoading = false;
    update();
  }

  Future<void> fetchPronunById(String id) async {
    final tableName = title.replaceAll(RegExp(r'[^\w]+'), '').toLowerCase();

    if (kIsWeb) {
      // ✅ Web: Fetch directly from Firebase (no local DB)
      final ref = FirebaseDatabase.instance.ref('$collectionName/$id');
      final snapshot = await ref.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<Object?, Object?>;
        final parsed = data.map((key, value) {
          if (value is Map) {
            return MapEntry(key.toString(), Map<String, dynamic>.from(value));
          } else if (value is List) {
            return MapEntry(
              key.toString(),
              value.map((e) => Map<String, dynamic>.from(e)).toList(),
            );
          } else {
            return MapEntry(key.toString(), value);
          }
        });

        category = Category.fromMap(parsed);
        List<SubcategoryPro> tempList = [];

        for (var item in category.subcategories) {
          String url = item.file;
          log("WEB mode → checking URL: $url");

          if (!url.startsWith("http")) {
            try {
              url = await FirebaseStorage.instance
                  .ref(item.file)
                  .getDownloadURL();
            } catch (e) {
              log("❌ Could not fetch URL for ${item.file}: $e");
            }
          }

          final newItem = SubcategoryPro(
            sentenceSamples: item.sentenceSamples,
            file: url,
            isPriority: item.isPriority,
            syllables: item.syllables,
            text: item.text,
            pronun: item.pronun,
            localPath: '', // Not needed in web
            downloadStatus: false, // Not used in web
            meaningSamples: item.meaningSamples,
          );

          tempList.add(newItem);
        }

        subcategories = tempList;
      } else {
        log('No Firebase data found for ID: $title');
        subcategories = [];
      }
    } else {
      // ✅ Mobile: Local DB first, fallback to Firebase
      final localData = await DBHelper.getAllSubcategoriesValidated(tableName);

      if (localData.isNotEmpty) {
        log('Loaded from local database for $id');
        subcategories = localData;
      } else {
        final ref = FirebaseDatabase.instance.ref('$collectionName/$id');
        final snapshot = await ref.get();

        if (snapshot.exists) {
          final data = snapshot.value as Map<Object?, Object?>;
          final parsed = data.map((key, value) {
            if (value is Map) {
              return MapEntry(key.toString(), Map<String, dynamic>.from(value));
            } else if (value is List) {
              return MapEntry(
                key.toString(),
                value.map((e) => Map<String, dynamic>.from(e)).toList(),
              );
            } else {
              return MapEntry(key.toString(), value);
            }
          });

          category = Category.fromMap(parsed);
          List<SubcategoryPro> tempList = [];

          for (var item in category.subcategories) {
            String url = item.file;
            print(
                "$url printing the url for to show how the thing is start with http or not");

            if (!url.startsWith("http")) {
              try {
                url = await FirebaseStorage.instance
                    .ref(item.file)
                    .getDownloadURL();
              } catch (e) {
                print("❌ Could not fetch URL for ${item.file}: $e");
              }
            }

            final newItem = SubcategoryPro(
              sentenceSamples: item.sentenceSamples,
              file: url,
              isPriority: item.isPriority,
              syllables: item.syllables,
              text: item.text,
              pronun: item.pronun,
              localPath: '',
              downloadStatus: false,
              meaningSamples: item.meaningSamples,
            );

            await DBHelper.insertSubcategory(newItem, tableName);
            tempList.add(newItem);
          }

          subcategories = tempList;
        } else {
          log('No Firebase data found for ID: $title');
          subcategories = [];
        }
      }
    }

    // ✅ Sort alphabetically by text (case-insensitive)
    subcategories
        .sort((a, b) => a.text.toLowerCase().compareTo(b.text.toLowerCase()));

    // ✅ Always refresh lists
    ogSubCategories = List.from(subcategories);
    masterList = List.from(ogSubCategories);
    filterBaseList = List.from(masterList);
    searchBaseList = List.from(masterList);

    isPriorityList =
        subcategories.map((e) => e.downloadStatus == true).toList();

    isLoading = false;
    update();
  }

  void clearSearch() {
    isSearching = false;
    searchController.clear();

    subcategories =
        isFiltering ? List.from(filterBaseList) : List.from(masterList);
    isPriorityList =
        subcategories.map((e) => e.downloadStatus == true).toList();
    update();
  }

  @override
  void onClose() {
    stopAllPlaying();
    audioPlayer.dispose();
    WakelockPlus.disable();

    super.onClose();
  }
}
