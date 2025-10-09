import 'dart:convert';

class Category {
  final String category;
  final List<SubcategoryPro> subcategories;

  Category({
    required this.category,
    required this.subcategories,
  });
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      category: map['category'] ?? '',
      subcategories: (map['subcategories'] as List<dynamic>)
          .map((item) => SubcategoryPro.fromMap(item))
          .toList(),
    );
  }
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      category: json['category'] ?? '',
      subcategories: (json['subcategories'] as List<dynamic>)
          .map((e) => SubcategoryPro.fromJson(e))
          .toList(),
    );
  }
}

class SubcategoryPro {
  final String file;
  String isPriority;
  final String syllables;
  final String text;
  final String pronun;
  bool downloadStatus;
  String localPath;
  List<String> sentenceSamples;
  List<String> meaningSamples;

  SubcategoryPro({
    required this.file,
    required this.isPriority,
    required this.syllables,
    required this.text,
    required this.pronun,
    this.downloadStatus = false,
    this.localPath = "",
    required this.sentenceSamples,
    required this.meaningSamples,
  });

  factory SubcategoryPro.fromJson(Map<String, dynamic> json) {
    return SubcategoryPro(
      file: json['file'] ?? '',
      isPriority: json['isPriority']?.toString() ?? '',
      syllables: json['syllables']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      pronun: json['pronun']?.toString() ?? '',
      downloadStatus:
          json['downloadStatus'] == 1 || json['downloadStatus'] == true,
      sentenceSamples: (json['sentenceSamples'] is String)
          ? List<String>.from(jsonDecode(json['sentenceSamples']))
          : (json['sentenceSamples'] ?? []).cast<String>(),
      localPath: json['localPath'] ?? '',
      meaningSamples: (json['meaningSamples'] is String)
          ? List<String>.from(jsonDecode(json['meaningSamples']))
          : (json['meaningSamples'] ?? []).cast<String>(),
    );
  }

  factory SubcategoryPro.fromMap(Map<String, dynamic> map) {
    return SubcategoryPro(
      file: map['file'] ?? '',
      isPriority: map['isPriority']?.toString() ?? "false",
      syllables: map['syllables'] ?? '',
      text: map['text'] ?? '',
      pronun: map['pronun'] ?? '',
      downloadStatus: map['downloadStatus'] == 1,
      localPath: map['localPath'] ?? "",
      sentenceSamples: (map['sentenceSamples'] != null)
          ? List<String>.from(jsonDecode(map['sentenceSamples']))
          : [],
      meaningSamples: (map['meaningSamples'] != null)
          ? List<String>.from(jsonDecode(map['meaningSamples']))
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'file': file,
      'isPriority': isPriority,
      'syllables': syllables,
      'text': text,
      'pronun': pronun,
      'downloadStatus': downloadStatus ? 1 : 0,
      'localPath': localPath,
      'sentenceSamples': jsonEncode(sentenceSamples),
      'meaningSamples': jsonEncode(meaningSamples),
    };
  }

  SubcategoryPro copyWith({
    List<String>? sentenceSamples,
    String? localPath,
    List<String>? meaningSamples,
  }) {
    return SubcategoryPro(
      file: file,
      isPriority: isPriority,
      syllables: syllables,
      text: text,
      pronun: pronun,
      downloadStatus: downloadStatus,
      localPath: localPath ?? this.localPath,
      sentenceSamples: sentenceSamples ?? this.sentenceSamples,
      meaningSamples: meaningSamples ?? this.meaningSamples,
    );
  }
}
