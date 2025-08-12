import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hotelmanagementapp/model/category_model.dart';
import 'package:hotelmanagementapp/public/audio_helper.dart';
import 'package:hotelmanagementapp/public/db_helper.dart';
import 'package:hotelmanagementapp/utility/speech_analytics_dialog.dart';

import 'package:just_audio/just_audio.dart';

class PronunciationLabSubController extends GetxController {
  late String title;
  late List<SubcategoryPro> subcategories = [];
  late CategoryModel category;
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

  @override
  void onInit() {
    audioPlayer = AudioPlayer();
    title = Get.arguments['title'];
    final argList = Get.arguments['subcategories'] as List;
    subcategories = argList
        .map((item) => item is SubcategoryPro
            ? item
            : SubcategoryPro.fromMap(Map<String, dynamic>.from(item)))
        .toList();

    collectionName = Get.arguments['pronunCollectionName'] ?? '';
    audioPlayer.playerStateStream.listen((state) {
      if (state.playing && state.processingState == ProcessingState.ready) {
        update();
      }
      if (state.processingState == ProcessingState.completed) {
        currentlyPlayingIndex = null;
        update();
      }
    });
    id = Get.arguments['id'] ?? "";
    if (id == "") {
      // elseCase();
      isPriorityList =
          subcategories.map((e) => e.downloadStatus == true).toList();
      isLoading = false;
    } else {
      fetchPronunById(id);
    }

    super.onInit();
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
    {
      try {
        // final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
        await DBHelper.toggleDownloadStatus(subcategories[index].file,
            title.replaceAll(RegExp(r'[^\w]+'), '').toLowerCase());
        bool newValue = !isPriorityList[index];
        isPriorityList[index] = newValue;
        update();
        print("✅ isPriority updated to $newValue at index $index");
      } catch (e) {
        print("❌ Failed to update isPriority at index $index: $e");
      }
    }
  }

  void handlePlayPause(int index) async {
    log("${subcategories[index].file}");
    loadingIndex = index;
    isPlaying = true;

    update();

    try {
      if (currentlyPlayingIndex == index) {
        await audioPlayer.pause();
        currentlyPlayingIndex = null;
      } else {
        await audioPlayer.stop();
        currentlyPlayingIndex = index;
        update();
        final url = subcategories[index].file;
        log("Playing audio from URL: $url");

        // final decryptedPath = await AudioCryptoHelper.decryptFile(
        //   subcategories[index].file,
        //   subcategories[index].text.replaceAll(' ', '_'), // sanitized name
        // );
        log("Decrypted path: $url");
        await audioPlayer.setUrl(url);
        await audioPlayer.play();
      }
      errorPlaying = -1; // Reset error state
    } on PlayerException catch (e) {
      print("❌ Audio player error: ${e.message}");
      if (e.code == 'MEDIA_UNAVAILABLE') {
        errorPlaying = index;
        currentlyPlayingIndex = null;
      } else {
        // Handle other player exceptions
        print("❌ Other audio player error: ${e.code}");
      }
    } on Exception catch (e) {
      print("❌ General audio error: $e");
      errorPlaying = index;
      currentlyPlayingIndex = null;
    } catch (e) {
      print("❌ Audio load error: $e");
      errorPlaying = index;
      currentlyPlayingIndex = null;
    } finally {
      loadingIndex = null;
      isPlaying = false;
      update();
    }
  }

  Future<void> elseCase() async {
    final formattedTitle =
        title.replaceAll(RegExp(r'[^\w]+'), '').toLowerCase();
    final localData = await DBHelper.getAllSubcategories(formattedTitle);

    if (localData.isNotEmpty) {
      // Normalize sentenceSamples after fetching from DB
      subcategories = localData.map((item) {
        if (item.sentenceSamples is! List<String>) {
          if (item.sentenceSamples is String) {
            try {
              item.sentenceSamples =
                  List<String>.from(jsonDecode(item.sentenceSamples as String));
            } catch (_) {
              item.sentenceSamples = <String>[];
            }
          } else {
            item.sentenceSamples = <String>[];
          }
        }
        return item;
      }).toList();

      isPriorityList =
          subcategories.map((e) => e.downloadStatus == true).toList();
      print('Loaded from local database (no ID case) for $title');
    } else {
      for (var item in subcategories) {
        await DBHelper.insertSubcategory(
          item.copyWith(
            sentenceSamples: List<String>.from(item.sentenceSamples),
          ),
          formattedTitle,
        );
      }
      isPriorityList =
          subcategories.map((e) => e.downloadStatus == true).toList();
      print('No local DB. Stored passed subcategories for $title');
    }

    isLoading = false;
    update();
  }

  Future<void> fetchPronunById(String id) async {
    final localData = await DBHelper.getAllSubcategories(
        title.replaceAll(RegExp(r'[^\w]+'), '').toLowerCase());

    if (localData.isNotEmpty) {
      subcategories = localData;
      isPriorityList =
          subcategories.map((e) => e.downloadStatus == true).toList();
      print('Loaded from local database for $id');
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

        category = CategoryModel.fromMap(parsed);

        List<SubcategoryPro> tempList = [];

        for (var item in category.subcategories) {
          // 4️⃣ Print each subcategory to inspect sentenceSamples
          log("🔍 Subcategory: ${item.text}");
          log("    ➡ sentenceSamples raw: ${item.sentenceSamples}");
          log("    ➡ sentenceSamples length: ${item.sentenceSamples.length}");

          final newItem = SubcategoryPro(
            sentenceSamples: item.sentenceSamples,
            file: item.file,
            isPriority: item.isPriority,
            syllables: item.syllables,
            text: item.text,
            pronun: item.pronun,
            downloadStatus: false,
          );

          await DBHelper.insertSubcategory(
            newItem,
            title.replaceAll(RegExp(r'[^\w]+'), '').toLowerCase(),
          );
          tempList.add(newItem);
        }

        subcategories = tempList;
        isPriorityList =
            subcategories.map((e) => e.downloadStatus == true).toList();

        log('🎯 Fetched from Firebase and saved locally for $title '
            '${subcategories.length} items');
      } else {
        print('No Firebase data found for ID: $title');
      }
      update();
    }

    isLoading = false;
    update();
  }
}
