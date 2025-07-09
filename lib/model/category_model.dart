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

  SubcategoryPro({
    required this.file,
    required this.isPriority,
    required this.syllables,
    required this.text,
    required this.pronun,
    this.downloadStatus = false,
  });

  factory SubcategoryPro.fromJson(Map<String, dynamic> json) {
    return SubcategoryPro(
      file: json['file'] ?? '',
      isPriority: json['isPriority'].toString() ?? "false",
      syllables: json['syllables'] ?? '',
      text: json['text'] ?? '',
      pronun: json['pronun'] ?? '',
      downloadStatus: json['downloadStatus'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'file': file,
      'isPriority': isPriority,
      'syllables': syllables,
      'text': text,
      'pronun': pronun,
      'downloadStatus': downloadStatus ? 1 : 0, // Convert bool to int
    };
  }

  factory SubcategoryPro.fromMap(Map<String, dynamic> map) {
    return SubcategoryPro(
      file: map['file'] ?? '',
      isPriority: map['isPriority'].toString() ?? "false",
      syllables: map['syllables'] ?? '',
      text: map['text'] ?? '',
      pronun: map['pronun'] ?? '',
      downloadStatus: map['downloadStatus'] == 1 ? true : false,
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
