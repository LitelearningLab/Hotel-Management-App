class SentenceModel {
  final int? id;
  final String file;
  final bool isPriority;
  final String text;
  bool isDownloaded;
  String localPath;

  SentenceModel({
    this.id,
    required this.file,
    required this.isPriority,
    required this.text,
    this.isDownloaded = false,
    this.localPath = '',
  });

  factory SentenceModel.fromJson(Map<String, dynamic> json) {
    return SentenceModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      file: json['file']?.toString() ?? '',
      isPriority: json['isPriority'] == true ||
          json['isPriority']?.toString().toLowerCase() == 'true',
      text: json['text']?.toString() ?? '',
      isDownloaded: json['isDownloaded'] == true ||
          json['isDownloaded']?.toString().toLowerCase() == 'true',
      localPath: json['localPath']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file': file,
      'isPriority': isPriority,
      'text': text,
      'isDownloaded': isDownloaded,
      'localPath': localPath,
    };
  }
}

class SubCategoryModel {
  final String id;
  final List<SentenceModel> sentence;

  SubCategoryModel({required this.id, required this.sentence});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    final sentenceList = json['sentence'];
    return SubCategoryModel(
      id: json['id']?.toString() ?? '',
      sentence: sentenceList is List
          ? sentenceList
              .map((e) => SentenceModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sentence': sentence.map((s) => s.toJson()).toList(),
    };
  }
}

class CategoryModel {
  final String categoryName;
  final List<SubCategoryModel> subCategories;

  CategoryModel({
    required this.categoryName,
    required this.subCategories,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final subCatList = json['subCategories'];
    return CategoryModel(
      categoryName: json['categoryName']?.toString() ?? '',
      subCategories: subCatList is List
          ? subCatList
              .map((e) => SubCategoryModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'subCategories': subCategories.map((sc) => sc.toJson()).toList(),
    };
  }
}

class SentenceLabModel {
  final String sectionName;
  final List<CategoryModel> categories;

  SentenceLabModel({
    required this.sectionName,
    required this.categories,
  });

  factory SentenceLabModel.fromJson(Map<String, dynamic> json) {
    final categoryList = json['categories'];
    return SentenceLabModel(
      sectionName: json['sectionName']?.toString() ?? '',
      categories: categoryList is List
          ? categoryList
              .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sectionName': sectionName,
      'categories': categories.map((c) => c.toJson()).toList(),
    };
  }
}
