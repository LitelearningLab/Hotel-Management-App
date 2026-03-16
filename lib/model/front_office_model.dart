class FrontOfficeDocument {
  final String category;
  final List<SubCategory> subcategory;
  final double order;
  final String key;
  final String pronunID;

  FrontOfficeDocument(
      {required this.category,
      required this.subcategory,
      required this.order,
      required this.key,
      required this.pronunID});

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
        order: (map['order'] ?? 0).toDouble(),
        key: map['key'] ?? "",
        pronunID: map['pronunID'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'subcategory': subcategory.map((e) => e.toMap()).toList(),
      'order': order,
      'key': key,
      'pronunID': pronunID,
    };
  }

  List<SubCategory> get subcategories => subcategory;
}

class SubCategory {
  final String name;
  final String link;
  final List<Map<String, String>> linkList;

  SubCategory({
    required this.name,
    required this.link,
    required this.linkList,
  });

  factory SubCategory.fromMap(Map<String, dynamic> map) {
    dynamic rawLink = map['link'];
    String extractedLink = '';
    List<Map<String, String>> extractedList = [];

    if (rawLink is String) {
      extractedLink = rawLink;
    } else if (rawLink is List) {
      for (var item in rawLink) {
        if (item is Map) {
          extractedList.add({
            'name': item['name'] ?? '',
            'link': item['link'] ?? '',
          });

          if (extractedLink.isEmpty &&
              (item['link'] ?? '').toString().isNotEmpty) {
            extractedLink = item['link'];
          }
        }
      }
    }

    return SubCategory(
      name: map['name'] ?? '',
      link: extractedLink,
      linkList: extractedList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'link': linkList.isNotEmpty ? linkList : link, // ✅ FIX HERE
    };
  }
}
