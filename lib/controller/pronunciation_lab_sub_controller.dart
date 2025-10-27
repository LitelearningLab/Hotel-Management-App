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
      argList = saved['subcategories'] ?? [];
      collectionName = saved['pronunCollectionName'] ?? '';
      id = saved['id'] ?? "";
    }
    debugPrint("collection name is $collectionName");
    debugPrint("argument list is $argList");
    debugPrint("title is $title");

    audioPlayer.setUrl(
        "https://firebasestorage.googleapis.com/v0/b/lite-learning-lab.appspot.com/o/Hotel%20Management%2FWhatsApp%20Audio%202025-09-09%20at%203.41.09%20PM.mp4?alt=media&token=b99d9096-211b-45cc-b157-4582c7fc3312");
    audioPlayer.play();
    ogSubCategories = argList
        .map((item) => item is SubcategoryPro
            ? item
            : SubcategoryPro.fromMap(Map<String, dynamic>.from(item)))
        .toList();

    audioPlayer.playerStateStream.listen((state) {
      if (state.playing && state.processingState == ProcessingState.ready) {
        update();
      }
      if (state.processingState == ProcessingState.completed) {
        currentlyPlayingIndex = null;
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

  void kShowDialog(String word, bool notCatch, BuildContext context) async {
    Get.dialog(
      Container(
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          child: SpeechAnalyticsDialog(
            true,
            isShowDidNotCatch: notCatch,
            word: word,
            title: "widget.title", // replace with actual title
            load: "widget.load", // replace with actual load
          ),
        ),
      ),
    ).then((value) async {
      if (value != null &&
          (value.isCorrect == "true" || value.isCorrect == "false")) {
        selectedWord = word;
        isCorrect = value.isCorrect == "true";
        log("is correct or not $isCorrect");

        final attempt = WordAttempt(
          batch: "yourBatch",
          companyId: collegeId,
          correct: isCorrect ? 1 : 0,
          date: "",
          lastAttempt: "",
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
      } else if (value != null && value.isCorrect == "notCatch") {
        kShowDialog(word, true, context);
      } else if (value != null && value.isCorrect == "openDialog") {
        kShowDialog(word, false, context);
      }
    }).onError((error, stackTrace) {
      log("Dialog error: $error");
    });
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
    ogSubCategories[index].downloadStatus =
        !ogSubCategories[index].downloadStatus;
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
        if (localPath.isNotEmpty && await File(localPath).exists()) {
          await File(localPath).delete();
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

  void handlePlayPause(int index) async {
    log("${subcategories[index].file}");
    loadingIndex = index;
    isPlaying = true;
    errorPlaying = -1;
    playingIs = index;
    update();

    try {
      if (currentlyPlayingIndex == index) {
        await audioPlayer.pause();
        currentlyPlayingIndex = null;
      } else {
        await audioPlayer.stop();
        currentlyPlayingIndex = index;

        String? playPath;
        if (subcategories[index].localPath.isNotEmpty &&
            await File(subcategories[index].localPath).exists()) {
          log("🔐 Decrypting local file before playing...");
          playPath = await AudioCryptoHelper.decryptFile(
            subcategories[index].localPath,
            subcategories[index]
                .text
                .replaceAll(' ', '_')
                .replaceAll(RegExp(r'[<>:"/\\|?*]'), ''),
          );
          log("Decrypted to temp file: $playPath");
        } else {
          playPath = subcategories[index].file; // URL
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
          title: title,
          userId: userId,
          word: subcategories[index].text,
        );

        await WordAttempt.saveAttempt(attempt);
      }
      errorPlaying = -1;
    } on PlayerException catch (e) {
      print("❌ Audio player error: ${e.message} ${subcategories[index].file}");
      errorPlaying = index;
      currentlyPlayingIndex = null;
    } on Exception catch (e) {
      print("❌ General audio error: $e");
      errorPlaying = index;
      currentlyPlayingIndex = null;
    } finally {
      // loadingIndex = null;
      isPlaying = false;
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
    final localData = await DBHelper.getAllSubcategories(tableName);
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
    subcategories = await DBHelper.getAllSubcategories(tableName);

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
      final localData = await DBHelper.getAllSubcategories(tableName);

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
}
