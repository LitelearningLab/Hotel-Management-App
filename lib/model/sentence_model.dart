class SentenceModel {
  final String file;
  final bool isPriority;
  final String text;

  SentenceModel({
    required this.file,
    required this.isPriority,
    required this.text,
  });

  factory SentenceModel.fromJson(Map<String, dynamic> json) {
    return SentenceModel(
      file: json['file'] ?? '',
      isPriority: json['isPriority'].toString().toLowerCase() == 'true',
      text: json['text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'file': file,
        'isPriority': isPriority,
        'text': text,
      };
}

class SubCategoryModel {
  final String id;
  final List<SentenceModel> sentence;

  SubCategoryModel({required this.id, required this.sentence});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'] ?? '',
      sentence: (json['sentence'] as List<dynamic>)
          .map((e) => SentenceModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sentence': sentence.map((s) => s.toJson()).toList(),
      };
}

class CategoryModel {
  final String categoryName;
  final List<SubCategoryModel> subCategories;

  CategoryModel({
    required this.categoryName,
    required this.subCategories,
  });
}

class SentenceLabModel {
  final String sectionName;
  final List<CategoryModel> categories;

  SentenceLabModel({
    required this.sectionName,
    required this.categories,
  });
}
