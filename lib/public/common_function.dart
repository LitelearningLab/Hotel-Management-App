import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

double kHeight = 0.0;
double kWidth = 0.0;
// double fullScreenHeight = 805.33;

double getWidgetHeight({required double height}) {
  double variableHeightValue = 812 / height;
  return kHeight / variableHeightValue;
}

double getWidgetWidth({required double width}) {
  double variableWidthValue = 375 / width;
  return kWidth / variableWidthValue;
}

Future<void> startPracticeTime({
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
    log(mainCategory);
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
    if (duration.inSeconds <= 0)
      throw ArgumentError('Duration must be positive');
    if (mainCategory.isEmpty) throw ArgumentError('Main category is required');
    if (subCategory.isEmpty) throw ArgumentError('Sub category is required');
    // 4. Create query to find existing document with matching fields
    final querySnapshot = await firestore
        .collection("collectionName")
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
      // 'endTime': endTimings,
      // 'startTime': startTime,
      // 'mainCategory': mainCategory,
      // 'recordTimings': timings,
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
      await firestore.collection("collectionName").add({
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


// double getFullWidgetHeight({required double height}) {
//   double variableHeightValue = 812 / height;
//   return fullScreenHeight / variableHeightValue;
// }
