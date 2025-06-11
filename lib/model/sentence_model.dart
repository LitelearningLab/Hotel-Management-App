class SentenceLabModel {
  final String category;
  final List<SubCategoryModelSentence> subcategory;

  SentenceLabModel({
    required this.category,
    required this.subcategory,
  });

  factory SentenceLabModel.fromMap(Map<String, dynamic> map) {
    return SentenceLabModel(
      category: map['category'] ?? '',
      subcategory: (map['subcategory'] as List)
          .map((e) =>
              SubCategoryModelSentence.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class SubCategoryModelSentence {
  final String subcategory;
  final List<FileModel> file;

  SubCategoryModelSentence({
    required this.subcategory,
    required this.file,
  });

  factory SubCategoryModelSentence.fromMap(Map<String, dynamic> map) {
    return SubCategoryModelSentence(
      subcategory: map['subcategory'] ?? '',
      file: (map['file'] as List)
          .map((e) => FileModel.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class FileModel {
  final String text;
  final String audio;

  FileModel({
    required this.text,
    required this.audio,
  });

  factory FileModel.fromMap(Map<String, dynamic> map) {
    return FileModel(
      text: map['text'] ?? '',
      audio: map['audio'] ?? '',
    );
  }
}
