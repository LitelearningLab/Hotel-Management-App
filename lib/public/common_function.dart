import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/model/grammer_lab_model.dart';
import 'package:hotelmanagementapp/model/sentence_model.dart';
import 'package:hotelmanagementapp/model/sound_model.dart';
import 'package:hotelmanagementapp/public/api.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

double kHeight = 0.0;
double kWidth = 0.0;
DateTime startTime = DateTime.now();
List<Map<String, DateTime>> timings = [];
DateTime startTimings = DateTime.now();
DateTime endTimings = DateTime.now();
int count = 0;
bool resume = true;
bool isTimerActive = false;
Timer? mainCatTimer;
Duration _timeSpent = Duration.zero;
Duration finalDuration = Duration.zero;
String mianCategoryTitile = "";
String sessionName2 = "";
String sessionName = "";
String subCategoryTitle = "";
String activityName = "";
int timestampIndex = 0;
late TextScaler kText;
String accessLinks = "";
// double fullScreenHeight = 805.33;

Size displaySize(BuildContext context) {
  //debugPrint('Size = ' + MediaQuery.of(context).size.toString());
  return MediaQuery.of(context).size;
}

double getWidgetHeight({required double height}) {
  double variableHeightValue = 812 / height;
  return kHeight / variableHeightValue;
}

double getWidgetWidth({required double width}) {
  double variableWidthValue = 375 / width;
  return kWidth / variableWidthValue;
}

double displayWidth(BuildContext context) {
  // debugPrint('Width = ' + displaySize(context).width.toString());
  return displaySize(context).width;
}

void openDialog(BuildContext context) {
  Get.snackbar(
    'Work in Progress',
    '',
    snackPosition: SnackPosition.BOTTOM,
    duration: Duration(seconds: 1),
    backgroundColor: Colors.transparent,
    colorText: Colors.black,
    margin: EdgeInsets.all(6),
    borderRadius: 5,
  );
}

void recordTiming(String state) {
  if (resume) {
    endTimings = DateTime.now();
    resume = false;

    Map<String, DateTime> timingEntry = {
      "startTime$count": startTimings,
      "endTime$count": endTimings
    };

    timings.add(timingEntry);
    count++;
  }
}

void startTimerMainCategory(String name) {
  log("entering to the start timer main category");
  // mianCategoryTitile = name;
  if (!isTimerActive) {
    count = 1;
    startTimings = DateTime.now();
    timings = [];
    startTime = DateTime.now();
    isTimerActive = true;
    mainCatTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resume) {
        _timeSpent += const Duration(seconds: 1);
        log("time spend inside the startermain category $_timeSpent");
      }
    });
  }
}

Future<void> stopTimerMainCategory() async {
  if (isTimerActive) {
    // if (count == 1) {
    // endTimings = DateTime.now();
    recordTiming("state");
    // }
    resume = true;

    // recordTiming("state");
    mainCatTimer?.cancel();
    isTimerActive = false;
    finalDuration = _timeSpent;
    _timeSpent = Duration.zero;
    await startPracticeTime(
      index: timestampIndex,
      duration: finalDuration,
      mainCategory: mianCategoryTitile,
      subCategory: subCategoryTitle, type: sessionName,
      activityName: activityName,
      topicNames: [],
      // sessionName: sessionName
    );
    activityName = "";
    sessionName = "";

    log("printing the timing is working or not $finalDuration ${mianCategoryTitile}");
  }
}

// double getFullWidgetHeight({required double height}) {
//   double variableHeightValue = 812 / height;
//   return fullScreenHeight / variableHeightValue;
// }
Future<void> startPracticeTime({
  required int index,
  required Duration duration,
  required String mainCategory,
  required String subCategory,
  required String type,
  required String activityName,
  required List<String> topicNames,
}) async {
  try {
    // 1. Check network
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No internet connection. Please check your network.');
    }
    print('✅ Internet connectivity verified.');

    // 2. Determine Firestore collection name based on index
    final String collectionName = index == 0
        ? CollectionNames.frontOfficeTimestamp
        : index == 1
            ? CollectionNames.foodAndBeverageTimestamp
            : index == 2
                ? CollectionNames.foodProductionTimestamp
                : index == 3
                    ? CollectionNames.houseKeepingTimestamp
                    : index == 4
                        ? CollectionNames.interactiveSimulationTimestamp
                        : index == 6
                            ? CollectionNames.langauqeLabTimestamp
                            : index == 7
                                ? CollectionNames.contentLabTimestamp
                                : throw Exception('Invalid index: $index');
    print('📂 Collection Name: $collectionName');

    // 3. Prepare Firestore instance
    final firestore = FirebaseFirestore.instance;
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId") ?? "";

    // 4. Attempt to find existing session document
    if (mainCategory == "English Pronunciation" ||
        mainCategory == "French Pronunciation" ||
        mainCategory == "Sentence Lab") {
      activityName = "Pronunciation Lab";
      type = "null";
    } else if (mianCategoryTitile == "Grammer Lab") {
      activityName = "Grammer Lab";
      type = "null";
    }
    final querySnapshot = await firestore
        .collection(collectionName)
        .where('userId', isEqualTo: userId)
        .where('category', isEqualTo: mainCategory)
        .where('subCategory', isEqualTo: subCategory)
        .where('type', isEqualTo: type)
        .where('activityName', isEqualTo: activityName)
        // .where('topicNames', isEqualTo: topicNames)
        .limit(1)
        .get();
    print('🔍 Query completed. Docs found: ${querySnapshot.docs.length}');

    // 5. Prepare session data
    print('⏱️ Duration (seconds): ${duration.inSeconds}');
    print('📌 Main Category: $mainCategory');
    print('📌 Sub Category: $subCategory');
    print('📌 Type: $type');
    print('📌 Activity Name: $activityName');
    print('📌 Topic Names: $topicNames');

    final newSession = {
      'duration': duration.inSeconds,
      'endTime': endTimings,
      'startTime': startTime,
      // 'mainCategory': mainCategory,
      'recordTimings': timings,
    };
    print('📘 New session data: $newSession');

    // 6. Update or Create Firestore document
    if (querySnapshot.docs.isNotEmpty) {
      final docRef = querySnapshot.docs.first.reference;
      print('📝 Updating existing document: ${docRef.id}');

      await docRef.update({
        'sessions': FieldValue.arrayUnion([newSession]),
        'totalPracticeTime': FieldValue.increment(duration.inSeconds),
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      print('✅ Existing document updated.');
    } else {
      // Get Shared Preferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString("userId") ?? "";
      final collegeId = prefs.getString("collegeId") ?? "";
      final batchName = prefs.getString("batchName") ?? "";

      print('👤 User ID: $userId');
      print('🏫 College ID: $collegeId');
      print('🎓 Batch Name: $batchName');

      if (userId.isEmpty) {
        throw Exception('User ID is empty. Please log in again.');
      }

      await firestore.collection(collectionName).add({
        'userId': userId,
        'category': mainCategory,
        'subCategory': subCategory,
        'type': type,
        'activityName': activityName,
        // activityName == "" && index != 7 ? "E-Learning" : activityName,
        // 'topicNames': topicNames,
        'sessions': [newSession],
        'totalPracticeTime': duration.inSeconds,
        'lastUpdated': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'collegeId': collegeId,
        'batchName': batchName,
      });

      print('✅ New document created successfully.');
    }

    print('📌 Practice session recorded completely.');
  } on FirebaseException catch (e) {
    print('🔥 Firestore Error: ${e.code} - ${e.message}');
    throw Exception('Failed to save session data: ${e.message}');
  } catch (e, stack) {
    print('❌ Unexpected Error: $e\nStack Trace: $stack');
    throw Exception('An unexpected error occurred');
  }
}

class TapPopup extends StatefulWidget {
  final VoidCallback onFinish;
  const TapPopup({required this.onFinish});

  @override
  State<TapPopup> createState() => _TapPopupState();
}

class _TapPopupState extends State<TapPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      reverseDuration: Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    Future.delayed(Duration(seconds: 3), () async {
      await _controller.reverse();
      widget.onFinish();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Material(
        elevation: 4,
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            'Coming Soon',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

List<TextSpan> buildTextSpans(String text) {
  List<TextSpan> spans = [];
  bool isWithinParentheses = false;
  StringBuffer buffer = StringBuffer();

  for (int i = 0; i < text.length; i++) {
    if (text[i] == '(') {
      if (buffer.isNotEmpty) {
        spans.add(TextSpan(
          text: buffer.toString(),
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              fontFamily: Keys.lucidaFontFamily),
        ));
        buffer.clear();
      }
      isWithinParentheses = true;
    } else if (text[i] == ')') {
      spans.add(TextSpan(
        text: ' ${buffer.toString()} ',
        style: TextStyle(
            color: Colors.yellow,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: Keys.lucidaFontFamily),
      ));
      buffer.clear();
      isWithinParentheses = false;
    } else {
      buffer.write(text[i]);
    }
  }
  if (buffer.isNotEmpty) {
    spans.add(TextSpan(
      text: buffer.toString(),
      style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          fontFamily: Keys.lucidaFontFamily),
    ));
  }

  return spans;
}

List<Map<String, dynamic>> recentHistory = [];

void addToRecentHistory({
  required String path,
  required String category,
  required String section,
  required String link,
  required String proLabTitle,
  List<SubCategoryModel>? subCategories,
  GrammarDoc? grammarDocs,
  SoundSubcategory? soundSubcategory,
}) async {
  final newEntry = {
    'path': path,
    'category': category,
    'section': section,
    'link': link,
    'proLabTitle': proLabTitle,
    'subCategories': subCategories?.map((e) => e.toJson()).toList() ?? [],
    'grammarDocs': grammarDocs != null ? grammarDocs.toJson() : {},
    'soundSub': soundSubcategory != null ? soundSubcategory.toJson() : {},
  };

  // Safe remove
  recentHistory.removeWhere((entry) =>
      entry['path'] == path &&
      entry['category'] == category &&
      entry['section'] == section &&
      entry['link'] == link &&
      entry['proLabTitle'] == proLabTitle);

  // ✅ Ensure list is not null
  recentHistory.insert(0, newEntry);

  if (recentHistory.length > 3) {
    recentHistory = recentHistory.sublist(0, 3);
  }

  final prefs = await SharedPreferences.getInstance();
  prefs.setString('recentHistory', jsonEncode(recentHistory));
}
