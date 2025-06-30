import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hotelmanagementapp/model/category_model.dart';
import 'package:hotelmanagementapp/utility/result_dialog.dart';
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
      bool newValue = !isPriorityList[index];
      // await dbRef
      //     .child(collectionName)
      //     .child(id)
      //     .child('subcategories')
      //     .child(index.toString())
      //     .update({'isPriority': newValue});
      isPriorityList[index] = newValue;
      update();
      print("✅ isPriority updated to $newValue at index $index");
    } catch (e) {
      print("❌ Failed to update isPriority at index $index: $e");
    }
  }

  void handlePlayPause(int index) async {
    loadingIndex = index;
    update();

    try {
      if (currentlyPlayingIndex == index) {
        await audioPlayer.pause();
        currentlyPlayingIndex = null;
        loadingIndex = null;
        update();
      } else {
        await audioPlayer.stop();
        await audioPlayer.setUrl(subcategories[index].file);
        currentlyPlayingIndex = index;
        loadingIndex = null;
        update();
        await audioPlayer.play();
      }
    } catch (e) {
      print("Audio load error: $e");
      currentlyPlayingIndex = null;
      loadingIndex = null;
      errorPlaying = index;
      update();
    } finally {
      loadingIndex = null;
      update();
    }
  }

  Future<void> fetchPronunById(String id) async {
    if (subcategories.isEmpty) {
      final ref = FirebaseDatabase.instance.ref('$collectionName/$id');

      try {
        final snapshot = await ref.get();

        if (snapshot.exists) {
          final data = snapshot.value as Map<Object?, Object?>;
          final parsed = data.map((key, value) {
            if (value is Map) {
              return MapEntry(
                  key.toString(), Map<String, dynamic>.from(value as Map));
            } else if (value is List) {
              return MapEntry(
                key.toString(),
                value.map((e) => Map<String, dynamic>.from(e as Map)).toList(),
              );
            } else {
              return MapEntry(key.toString(), value);
            }
          });

          category = CategoryModel.fromMap(parsed);
          subcategories = category.subcategories;
          isPriorityList =
              subcategories.map((e) => e.isPriority == true).toList();
        } else {
          print('No data found for ID: $id');
        }
      } catch (e) {
        print('Error fetching data: $e');
      }

      isLoading = false;
      update();
      print('No subcategories found for title: $title $collectionName');
    } else {
      isLoading = false;
      update();
      print('Subcategories for $title: ${subcategories.length}');
    }
  }
}
