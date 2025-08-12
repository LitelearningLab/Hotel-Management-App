import 'dart:convert';

class Category {
  final String category;
  final List<SubcategoryPro> subcategories;

  Category({
    required this.category,
    required this.subcategories,
  });

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

  SubcategoryPro({
    required this.file,
    required this.isPriority,
    required this.syllables,
    required this.text,
    required this.pronun,
    this.downloadStatus = false,
    this.localPath = "",
    required this.sentenceSamples,
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
      sentenceSamples: (map['sentenceSamples'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
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
      'sentenceSamples': sentenceSamples
    };
  }

  SubcategoryPro copyWith({
    List<String>? sentenceSamples,
    String? localPath,
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
    );
  }
}

class CategoryModel {
  final String category;
  final List<SubcategoryPro> subcategories;

  CategoryModel({
    required this.category,
    required this.subcategories,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      category: map['category'] ?? '',
      subcategories: (map['subcategories'] as List<dynamic>)
          .map((item) => SubcategoryPro.fromMap(item))
          .toList(),
    );
  }
}
