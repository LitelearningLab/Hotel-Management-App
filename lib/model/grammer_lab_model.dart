class GrammarDoc {
  final String category;
  final int order;
  final String id;
  final String key;
  final List<GrammerSub> subcategory;

  GrammarDoc({
    required this.category,
    required this.order,
    required this.id,
    required this.key,
    required this.subcategory,
  });

  factory GrammarDoc.fromJson(Map<String, dynamic> json) {
    var subcategoriesJson = json['subcategory'] as List<dynamic>;
    return GrammarDoc(
      category: json['category'] ?? '',
      order: json['order'] ?? 0,
      id: json['id'] ?? '',
      key: json['key'] ?? '',
      subcategory:
          subcategoriesJson.map((e) => GrammerSub.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'order': order,
      'id': id,
      'key': key,
      'subcategory': subcategory.map((e) => e.toJson()).toList(),
    };
  }
}

class GrammerSub {
  final String text;
  final String learningModule;
  final String exercise;

  GrammerSub({
    required this.text,
    required this.learningModule,
    required this.exercise,
  });

  factory GrammerSub.fromJson(Map<String, dynamic> json) {
    return GrammerSub(
      text: json['text'] ?? '',
      learningModule: json['learningModule'] ?? '',
      exercise: json['exercise'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'learningModule': learningModule,
      'exercise': exercise,
    };
  }
}
