import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hotelmanagementapp/public/constant.dart';

import 'package:get/get.dart';

import 'package:hotelmanagementapp/model/category_model.dart';
import 'package:hotelmanagementapp/public/audio_helper.dart';
import 'package:hotelmanagementapp/public/db_helper.dart';
import 'package:hotelmanagementapp/utility/speech_analytics_dialog.dart';

import 'package:just_audio/just_audio.dart';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

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
  int playingIs = -1;
  int isSaving = -1;

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
      elseCase();
      // isPriorityList =
      //     subcategories.map((e) => e.downloadStatus == true).toList();
      // isLoading = false;
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
    isSaving = index;
    String tableName = title.replaceAll(RegExp(r'[^\w]+'), '').toLowerCase();
    String fileKey = subcategories[index].file; // Use exact file key
    String fileName = subcategories[index].text.replaceAll(' ', '_');
    String url = subcategories[index].file;

    // Toggle current UI state first
    bool newValue = !isPriorityList[index];
    isPriorityList[index] = newValue;
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
            subcategories[index].text.replaceAll(' ', '_'),
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
      }
      errorPlaying = -1;
    } on PlayerException catch (e) {
      print("❌ Audio player error: ${e.message}");
      errorPlaying = index;
      currentlyPlayingIndex = null;
    } on Exception catch (e) {
      print("❌ General audio error: $e");
      errorPlaying = index;
      currentlyPlayingIndex = null;
    } finally {
      loadingIndex = null;
      isPlaying = false;
      update();
    }
  }

  Future<void> elseCase() async {
    final tableName = title.replaceAll(RegExp(r'[^\w]+'), '').toLowerCase();
    await DBHelper.ensureTableExists(tableName);

    final localData = await DBHelper.getAllSubcategories(tableName);

    if (localData.isEmpty) {
      log("No local data found, inserting passed subcategories...");
      for (var item in subcategories) {
        await DBHelper.insertSubcategory(item, tableName);
      }
    } else {
      log("Local data exists, skipping insert.");
    }

    // Reload from DB to keep localPath, downloadStatus intact
    subcategories = await DBHelper.getAllSubcategories(tableName);
    isPriorityList =
        subcategories.map((e) => e.downloadStatus == true).toList();

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
