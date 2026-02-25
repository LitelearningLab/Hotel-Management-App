import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hotelmanagementapp/dbHelper/db_helper.dart';
import 'package:hotelmanagementapp/model/category_model.dart';
import 'package:hotelmanagementapp/model/word_attempt.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/audio_helper.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/firebase_service.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/speech_analytics_dialog.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PronunciationLabController extends GetxController {
  late DatabaseReference databaseRef;
  List<Category> categories = <Category>[].obs;
  List<SubcategoryPro> searchBaseList = [];
  List<SubcategoryPro> subcategories = [];
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  RxString title = "Pronunciation Lab".obs;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  int? currentlyPlayingIndex;
  bool isPlaying = false;
  int playingIs = -1;
  int isSaving = -1;
  int errorPlaying = -1;
  late AudioPlayer audioPlayer;
  String userId = "";
  String collegeId = "";
  String batchName = "";
  String selectedWord = "";
  bool isCorrect = false;
  List<bool> isPriorityList = [];

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

  List<Map<String, dynamic>> pronunciationLabList = [
    {
      'title': 'Days, Dates, Months & Numbers',
      'load': 'daysdates',
      'menuText': 'Days, Dates, Months & Numbers',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.plDays,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'title': 'Letters Of The English Alphabet',
      'load': 'Latters and NATO',
      'menuText': 'Letters Of The English Alphabet',
      'backgroundImage': AllAssets.back2,
      'image': AllAssets.plLetters,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'title': 'US States & Cities',
      'load': 'States and Cities',
      'menuText': 'US States & Cities',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.plUSState,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'title': 'Most Commonly Used Words',
      'load': 'CommonWords',
      'menuText': 'Most Commonly Used Words',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.plMostCommon,
      'bgColor': Color(0xFF8540C8),
    },
    {
      'title': 'Common American Names',
      'load': 'ProcessWords',
      'menuText': 'Common American Names',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.plCommon,
      'bgColor': Color(0xFFFF6548),
    },
    {
      'title': 'Restaurant, Hotel & Travel',
      'load': 'Restaurant Hotel Travel',
      'menuText': 'Restaurant, Hotel & Travel',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.plRestaurant,
      'bgColor': Color(0xFF5146FF),
    },
    {
      'title': 'Business Words',
      'load': 'Business Words',
      'menuText': 'Business Words',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.plBusiness,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'title': 'Information Technology',
      'load': 'Information Technology',
      'menuText': 'Information Technology',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.plIT,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'title': 'Days, Dates, Months & Numbers',
      'load': 'daysdates',
      'menuText': 'Days, Dates, Months & Numbers',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.plDays,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'title': 'Letters Of The English Alphabet',
      'load': 'Latters and NATO',
      'menuText': 'Letters Of The English Alphabet',
      'backgroundImage': AllAssets.back2,
      'image': AllAssets.plLetters,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'title': 'US States & Cities',
      'load': 'States and Cities',
      'menuText': 'US States & Cities',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.plUSState,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'title': 'Most Commonly Used Words',
      'load': 'CommonWords',
      'menuText': 'Most Commonly Used Words',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.plMostCommon,
      'bgColor': Color(0xFF8540C8),
    },
    {
      'title': 'Common American Names',
      'load': 'ProcessWords',
      'menuText': 'Common American Names',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.plCommon,
      'bgColor': Color(0xFFFF6548),
    },
    {
      'title': 'Restaurant, Hotel & Travel',
      'load': 'Restaurant Hotel Travel',
      'menuText': 'Restaurant, Hotel & Travel',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.plRestaurant,
      'bgColor': Color(0xFF5146FF),
    },
    {
      'title': 'Business Words',
      'load': 'Business Words',
      'menuText': 'Business Words',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.plBusiness,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'title': 'Information Technology',
      'load': 'Information Technology',
      'menuText': 'Information Technology',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.plIT,
      'bgColor': Color(0xFF3DBAD3),
    },
  ];
  @override
  void onInit() {
    final args = Get.arguments as Map<String, dynamic>?;
    final box = GetStorage();
    if (args != null) {
      title.value = args['title'] ?? "";
    } else {
      final saved = box.read(AppRoutes.pronunciationLab) ?? {};
      title.value = saved['title'] ?? "";
    }
    debugPrint("PronunciationLabController title: ${title.value}");

    audioPlayer = AudioPlayer();
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
    databaseRef = FirebaseDatabase.instance.ref(
        title.value == "English Pronunciation"
            ? "EnglishLabCollection"
            : "FrenchLabCollection");
    _fetchData();
    log("PronunciationLabController initialized with title: ${title.value}");

    super.onInit();
  }

  Future<void> _fetchData() async {
    isLoading.value = true;

    try {
      DatabaseEvent event = await databaseRef.once();
      final data = event.snapshot.value;
      if (data is List) {
        log("📊 Firebase returned a list of length: ${data.length}");
      } else {
        log("⚠️ Firebase data is not a List. Type: ${data.runtimeType}");
      }
      // log("📥 Raw snapshot: $data");

      if (data != null && data is List) {
        categories = data.map((item) {
          final categoryMap = Map<String, dynamic>.from(item as Map);

          // Ensure subcategories are a List<Map<String, dynamic>>
          if (categoryMap['subcategories'] is List) {
            categoryMap['subcategories'] =
                (categoryMap['subcategories'] as List).map((subcat) {
              final subcatMap = Map<String, dynamic>.from(subcat);

              // 🔹 Normalize sentenceSamples to List<String>
              if (subcatMap['sentenceSamples'] is List) {
                subcatMap['sentenceSamples'] =
                    (subcatMap['sentenceSamples'] as List)
                        .map((e) => e.toString())
                        .toList();
              } else {
                subcatMap['sentenceSamples'] = <String>[];
              }

              return subcatMap;
            }).toList();
          }

          return Category.fromJson(categoryMap);
        }).toList();

        log("✅ Data loaded: ${categories.length} categories");

        // 🔹 First-time clear logic
        final prefs = await SharedPreferences.getInstance();
        final hasCleared = prefs.getBool("categoriesCleared1") ?? false;

        if (!hasCleared) {
          log("🗑 First-time run → clearing all category tables...");
          for (var cat in categories) {
            final tableName =
                cat.category.replaceAll(RegExp(r'[^\w]+'), '').toLowerCase();
            await DBHelper.clearTable(tableName);
          }
          await prefs.setBool("categoriesCleared1", true);
          log("✅ All category tables cleared once.");
        }

        if (categories.isNotEmpty && categories[0].subcategories.isNotEmpty) {
          log("📜 First subcategory sentenceSamples: ${categories[0].subcategories[0].sentenceSamples}");
        }
      } else {
        errorMessage.value = "No data found or invalid format.";
        log("⚠️ No data found or invalid format.");
      }
    } catch (e) {
      errorMessage.value = "Error: ${e.toString()}";
      log("❌ Error fetching data from Firebase: ${e.toString()}");
    } finally {
      isLoading.value = false;
      update();
    }
    isLoading.value = false;
    update();
  }

  void clearSearch() {
    isSearching = false;
    searchController.text = "";
    update();
  }

  void searchSubcategories(String query) {
    isSearching = query.trim().isNotEmpty;

    // Pick the base category list
    List<Category> base = categories;

    if (isSearching) {
      // 🔍 Flatten and filter all subcategories from all categories
      searchBaseList = base.expand((cat) => cat.subcategories).where((sub) {
        final q = query.toLowerCase();
        return sub.text.toLowerCase().contains(q) ||
            sub.syllables.toLowerCase().contains(q) ||
            sub.pronun.toLowerCase().contains(q) ||
            sub.sentenceSamples.any((s) => s.toLowerCase().contains(q)) ||
            sub.meaningSamples.any((m) => m.toLowerCase().contains(q));
      }).toList();

      subcategories = List.from(searchBaseList);
    } else {
      // 🔁 If no search, show all subcategories from all categories
      subcategories = base.expand((cat) => cat.subcategories).toList();
    }
    print(
        "jhere im printing the search length after searching ${subcategories.length}");

    isPriorityList =
        subcategories.map((e) => e.downloadStatus == true).toList();
    update();
  }

  void handlePlayPause(int index) async {
    log("${subcategories[index].file}");
    // loadingIndex = index;
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

        final tableName =
            title.value.replaceAll(RegExp(r'[^\w]+'), '').toLowerCase();
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
          title: title.value,
          userId: userId,
          word: subcategories[index].text,
        );

        await WordAttempt.saveAttempt(attempt);
      }
      errorPlaying = -1;
      update();
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
      update();
    }
  }

  void saveUpdate(int index) async {
    isSaving = index;
    String tableName =
        title.value.replaceAll(RegExp(r'[^\w]+'), '').toLowerCase();
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
          title: title.value,
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
}
