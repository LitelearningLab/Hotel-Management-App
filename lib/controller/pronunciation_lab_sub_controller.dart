import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
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
    subcategories = Get.arguments['subcategories'] as List<SubcategoryPro>;
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
      isPriorityList = List.filled(subcategories.length, false);
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

        final decryptedPath = await AudioCryptoHelper.decryptFile(
          subcategories[index].file,
          subcategories[index].text.replaceAll(' ', '_'), // sanitized name
        );
        log("Decrypted path: $decryptedPath");
        await audioPlayer.setUrl(decryptedPath);
        await audioPlayer.play();

        currentlyPlayingIndex = index;
        update();
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
          final encryptedPath = await AudioCryptoHelper.downloadAndEncryptFile(
              item.file, item.text);
          log("Encrypted path: $encryptedPath && time.file: ${item.file}");

          final newItem = SubcategoryPro(
            file: encryptedPath,
            isPriority: item.isPriority,
            syllables: item.syllables,
            text: item.text,
            pronun: item.pronun,
            downloadStatus: false,
          );

          await DBHelper.insertSubcategory(
              newItem, title.replaceAll(RegExp(r'[^\w]+'), '').toLowerCase());
          tempList.add(newItem);
        }

        subcategories = tempList;
        isPriorityList =
            subcategories.map((e) => e.downloadStatus == true).toList();
        print('Fetched from Firebase and saved locally for $title');
      } else {
        print('No Firebase data found for ID: $title');
      }
    }

    isLoading = false;
    update();
  }
}
