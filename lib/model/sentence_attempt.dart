import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SentenceAttempt {
  String batch;
  String companyId;
  int correct;
  String dateTime;
  List<Map<String, dynamic>> focusWord; // 🔹 List of maps

  String lastAttempt;
  double lastScore;
  int listAtt;
  String load;
  String main;
  int pracAtt;
  double score;
  String sentence;
  int time;
  int timeCal;
  String title;
  String userId;

  SentenceAttempt({
    required this.batch,
    required this.companyId,
    required this.correct,
    required this.dateTime,
    required this.focusWord,
    required this.lastAttempt,
    required this.lastScore,
    required this.listAtt,
    required this.load,
    required this.main,
    required this.pracAtt,
    required this.score,
    required this.sentence,
    required this.time,
    required this.timeCal,
    required this.title,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'batch': batch,
      'companyId': companyId,
      'correct': correct,
      'dateTime': dateTime,
      'focusWord': focusWord,
      'lastAttempt': lastAttempt,
      'lastScore': lastScore,
      'listatt': listAtt,
      'load': load,
      'main': main,
      'pracatt': pracAtt,
      'score': score,
      'sentence': sentence,
      'time': time,
      'timeCal': timeCal,
      'title': title,
      'userId': userId,
    };
  }

  factory SentenceAttempt.fromJson(Map<String, dynamic> json) {
    return SentenceAttempt(
      batch: json['batch'],
      companyId: json['companyId'],
      correct: json['correct'],
      dateTime: json['dateTime'],
      focusWord: List<Map<String, dynamic>>.from(json['focusWord'] ?? []),
      lastAttempt: json['lastAttempt'],
      lastScore: (json['lastScore'] as num).toDouble(),
      listAtt: json['listatt'],
      load: json['load'],
      main: json['main'],
      pracAtt: json['pracatt'],
      score: (json['score'] as num).toDouble(),
      sentence: json['sentence'],
      time: json['time'],
      timeCal: json['timeCal'],
      title: json['title'],
      userId: json['userId'],
    );
  }

  /// Save function with focusWord APPEND
  static Future<void> saveAttempt(SentenceAttempt newAttempt) async {
    final now = DateTime.now().toString();
    final collection =
        FirebaseFirestore.instance.collection('SentenceLabReports');

    try {
      if (kDebugMode) {
        print(
            "🔎 [SAVE_ATTEMPT] Checking existing reports for userId=${newAttempt.userId}, "
            "companyId=${newAttempt.companyId}, title=${newAttempt.title}, sentence=${newAttempt.sentence}");
      }

      final query = await collection
          .where('userId', isEqualTo: newAttempt.userId)
          .where('companyId', isEqualTo: newAttempt.companyId)
          .where('title', isEqualTo: newAttempt.title)
          .where('sentence', isEqualTo: newAttempt.sentence)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final docId = query.docs.first.id;
        final existing = query.docs.first.data();

        if (kDebugMode) {
          print("📄 Existing document found with id=$docId");
          print("📄 Existing data: $existing");
        }

        // 🔹 Existing focusWord list
        final List<Map<String, dynamic>> existingFocus =
            List<Map<String, dynamic>>.from(existing['focusWord'] ?? []);

        // 🔹 Append new attempt's focusWord items
        final List<Map<String, dynamic>> updatedFocus = [
          ...existingFocus,
          ...newAttempt.focusWord,
        ];

        if (kDebugMode) {
          print("🔄 Updated focusWord list: $updatedFocus");
        }
        if (newAttempt.listAtt == 1) {
          await collection.doc(docId).update({
            'listatt': (existing['listatt'] ?? 0) + newAttempt.listAtt,
          });
        } else {
          await collection.doc(docId).update({
            'correct': (existing['correct'] ?? 0) + newAttempt.correct,
            'listatt': (existing['listatt'] ?? 0) + newAttempt.listAtt,
            'pracatt': (existing['pracatt'] ?? 0) + newAttempt.pracAtt,
            'time': (existing['time'] ?? 0) + newAttempt.time,
            'timeCal': newAttempt.timeCal,
            'lastAttempt': now,
            'lastScore': newAttempt.score,
            'score': newAttempt.score, // overwrite with latest
            'focusWord': updatedFocus, // 🔹 keep appending
          });
        }

        if (kDebugMode) {
          print("✅ Document $docId successfully updated!");
        }
      } else {
        if (kDebugMode) {
          print("📄 No existing document found. Creating new one.");
        }
        newAttempt.lastAttempt = now;
        newAttempt.dateTime = now;

        final newDoc = await collection.add(newAttempt.toJson());
        if (kDebugMode) {
          print("✅ New document created with id=${newDoc.id}");
        }
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print("❌ Error while saving attempt: $e");
        print("❌ StackTrace: $stack");
      } else {
        print("❌ Error while saving attempt: $e");
      }
    }
  }
}
