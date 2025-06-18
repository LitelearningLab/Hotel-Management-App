import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/public/api.dart';

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
    'Coming Soon', // Title
    '', // Message (can be empty)
    snackPosition: SnackPosition.BOTTOM,
    duration: Duration(seconds: 3),
    backgroundColor: Colors.black87,
    colorText: Colors.white,
    margin: EdgeInsets.all(16),
    borderRadius: 10,
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

stopTimerMainCategory() async {
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
    // 1. Check network and validate inputs
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No internet connection. Please check your network.');
    }

    // 2. Get user ID
    // final userId = await SharedPref.getSavedString('userId');
    // if (userId.isEmpty) throw Exception('User not authenticated');

    // 3. Configure Firestore
    final firestore = FirebaseFirestore.instance;
    // log(mainCategory);
    // String collectionName = "processLearningTimeStamp";
    // if (mianCategoryTitile == "Process Learning") {
    //   collectionName = "processLearningTimeStamp";
    // } else if (mianCategoryTitile == "AR Call Simulation") {
    //   collectionName = "ARCallSimulationTimeStamp";
    // } else if (mianCategoryTitile == "Profluent English") {
    //   collectionName = "ProfluentEnglishTimeStamp";
    //   if (subCategory == "Sentence Lab" ||
    //       subCategory == "Call Flow Lab" ||
    //       subCategory == "Grammer Lab") {
    //     activityName = sessionName2;
    //   }
    // } else if (mianCategoryTitile == "Soft Skills") {
    //   collectionName = "SoftSkillsTimeStamp";
    //   subCategory = sessionName;
    // }
    // if (duration.inSeconds <= 0) {
    //   throw ArgumentError('Duration must be positive');
    // }
    // if (mainCategory.isEmpty) throw ArgumentError('Main category is required');
    // if (subCategory.isEmpty) throw ArgumentError('Sub category is required');
    // 4. Create query to find existing document with matching fields
    final String collectionName = index == 0
        ? CollectionNames.frontOfficeTimestamp
        : index == 1
            ? CollectionNames.foodAndBeverageTimestamp
            : index == 2
                ? CollectionNames.foodProductionTimestamp
                : index == 3
                    ? CollectionNames.houseKeepingTimestamp
                    : index == -1
                        ? CollectionNames.interactiveSimulationTimestamp
                        : "";
    log(collectionName);
    final querySnapshot = await firestore
        .collection(collectionName)
        .where('userId', isEqualTo: "userId")
        .where('category', isEqualTo: mainCategory)
        .where('subCategory', isEqualTo: subCategory)
        .where('type', isEqualTo: type)
        .where('activityName', isEqualTo: activityName)
        // .where('topicNames', isEqualTo: topicNames)
        .limit(1)
        .get();

    // 5. Prepare session data
    final newSession = {
      'duration': duration.inSeconds,
      'endTime': endTimings,
      'startTime': startTime,
      // 'mainCategory': mainCategory,
      'recordTimings': timings,
    };

    // 6. Update existing doc or create new one
    if (querySnapshot.docs.isNotEmpty) {
      // Document exists - update it
      final docRef = querySnapshot.docs.first.reference;
      await docRef.update({
        'sessions': FieldValue.arrayUnion([newSession]),
        'totalPracticeTime': FieldValue.increment(duration.inSeconds),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } else {
      // String company = await SharedPref.getSavedString("companyId");
      // String batch = await SharedPref.getSavedString("batch");
      // Document doesn't exist - create new
      await firestore.collection(collectionName).add({
        'userId': "userId",
        'category': mainCategory,
        'subCategory': subCategory,
        'type': type,
        'activityName': activityName == "" ? "E-Learning" : activityName,
        // 'topicNames': topicNames,
        'sessions': [newSession],
        'totalPracticeTime': duration.inSeconds,
        'lastUpdated': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'companyID': "company",
        'batchName': "batch"
      });
    }

    if (kDebugMode) {
      log('✅ Session recorded successfully');
    }
  } on FirebaseException catch (e) {
    log('🔥 Firestore Error: ${e.code} - ${e.message}');
    throw Exception('Failed to save session data: ${e.message}');
  } catch (e, stack) {
    log('❌ Unexpected Error: $e\nStack Trace: $stack');
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
