class FrontOfficeDocument {
  final String category;
  final List<SubCategory> subcategory;
  final int order;

  FrontOfficeDocument({
    required this.category,
    required this.subcategory,
    required this.order,
  });

  factory FrontOfficeDocument.fromMap(Map<String, dynamic> map) {
    var subcatList = <SubCategory>[];
    if (map['subcategory'] != null) {
      subcatList = List<Map<String, dynamic>>.from(map['subcategory'])
          .map((subcatMap) => SubCategory.fromMap(subcatMap))
          .toList();
    }

    return FrontOfficeDocument(
      category: map['category'] ?? '',
      subcategory: subcatList,
      order: map['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'subcategory': subcategory.map((e) => e.toMap()).toList(),
      'order': order,
    };
  }
}

class SubCategory {
  final String name;
  final String link;

  SubCategory({
    required this.name,
    required this.link,
  });

  factory SubCategory.fromMap(Map<String, dynamic> map) {
    return SubCategory(
      name: map['name'] ?? '',
      link: map['link'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'link': link,
    };
  }
}
