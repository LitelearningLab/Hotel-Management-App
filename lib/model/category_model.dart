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
  final bool isPriority;
  final String syllables;
  final String text;
  final String pronun;

  SubcategoryPro({
    required this.file,
    required this.isPriority,
    required this.syllables,
    required this.text,
    required this.pronun,
  });

  factory SubcategoryPro.fromJson(Map<String, dynamic> json) {
    return SubcategoryPro(
      file: json['file'] ?? '',
      isPriority: json['isPriority'] ?? false,
      syllables: json['syllables'] ?? '',
      text: json['text'] ?? '',
      pronun: json['pronun'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'file': file,
      'isPriority': isPriority,
      'syllables': syllables,
      'text': text,
      'pronun': pronun,
    };
  }
}
