import 'package:cloud_firestore/cloud_firestore.dart';

class WordAttempt {
  String batch;
  String companyId;
  int correct;
  String date; 
  String lastAttempt; 
  int listAtt;
  String load;
  int pracAtt;
  int time;
  int timeCal;
  String title;
  String userId;
  String word;

  WordAttempt({
    required this.batch,
    required this.companyId,
    required this.correct,
    required this.date,
    required this.lastAttempt,
    required this.listAtt,
    required this.load,
    required this.pracAtt,
    required this.time,
    required this.timeCal,
    required this.title,
    required this.userId,
    required this.word,
  });

  Map<String, dynamic> toJson() {
    return {
      'batch': batch,
      'companyId': companyId,
      'correct': correct,
      'date': date,
      'lastAttempt': lastAttempt,
      'listAtt': listAtt,
      'load': load,
      'pracAtt': pracAtt,
      'time': time,
      'timeCal': timeCal,
      'title': title,
      'userId': userId,
      'word': word,
    };
  }

  factory WordAttempt.fromJson(Map<String, dynamic> json) {
    return WordAttempt(
      batch: json['batch'],
      companyId: json['companyId'],
      correct: json['correct'],
      date: json['date'],
      lastAttempt: json['lastAttempt'],
      listAtt: json['listAtt'],
      load: json['load'],
      pracAtt: json['pracAtt'],
      time: json['time'],
      timeCal: json['timeCal'],
      title: json['title'],
      userId: json['userId'],
      word: json['word'],
    );
  }

  
  static Future<void> saveAttempt(WordAttempt newAttempt) async {
    final now = DateTime.now().toIso8601String();

    final collection =
        FirebaseFirestore.instance.collection('ProLabReports');

    
    final query = await collection
        .where('userId', isEqualTo: newAttempt.userId)
        .where('companyId', isEqualTo: newAttempt.companyId)
        .where('title', isEqualTo: newAttempt.title)
        .where('word', isEqualTo: newAttempt.word)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
    
      final docId = query.docs.first.id;
      final existing = query.docs.first.data();

      await collection.doc(docId).update({
        'correct': (existing['correct'] ?? 0) + newAttempt.correct,
        'pracAtt': (existing['pracAtt'] ?? 0) + newAttempt.pracAtt,
        'listAtt': (existing['listAtt'] ?? 0) + newAttempt.listAtt,
        'time': (existing['time'] ?? 0) + newAttempt.time,
        'timeCal': (existing['timeCal'] ?? 0) + newAttempt.timeCal,
        'lastAttempt': now,
      });
    } else {
    
      newAttempt.date = now;
      newAttempt.lastAttempt = now;
      await collection.add(newAttempt.toJson());
    }
  }
}
