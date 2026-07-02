class UniversityModel {
  final String collegeName;
  final String collegeId;
  final List<UniversityCategory> category;
  final String photo;

  UniversityModel({
    required this.collegeName,
    required this.collegeId,
    required this.category,
    required this.photo,
  });

  factory UniversityModel.fromMap(Map<String, dynamic> map) {
    final categoryList = (map['category'] as List<dynamic>?)
            ?.map((item) =>
                UniversityCategory.fromMap(Map<String, dynamic>.from(item)))
            .toList() ??
        [];
    categoryList.sort((a, b) {
      final aOrder = int.tryParse(a.order) ?? 0;
      final bOrder = int.tryParse(b.order) ?? 0;
      return aOrder.compareTo(bOrder);
    });

    return UniversityModel(
      collegeName: map['collegeName'] ?? '',
      collegeId: map['collegeId'] ?? '',
      category: categoryList,
      photo: map['photo'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'collegeName': collegeName,
      'collegeId': collegeId,
      'category': category.map((x) => x.toMap()).toList(),
      'photo': photo,
    };
  }

  factory UniversityModel.fromJson(Map<String, dynamic> json) =>
      UniversityModel.fromMap(json);
  Map<String, dynamic> toJson() => toMap();
}

class UniversityCategory {
  final String name;
  final String order;
  final String id;
  final String key;
  final List<Subject> subcategory;

  UniversityCategory({
    required this.name,
    required this.order,
    required this.id,
    required this.key,
    required this.subcategory,
  });

  factory UniversityCategory.fromMap(Map<String, dynamic> map) {
    return UniversityCategory(
      name: map['name'] ?? '',
      order: map['order'] ?? "0",
      id: map['id'] ?? '',
      key: map['key'] ?? '',
      subcategory: (map['subcategory'] as List<dynamic>?)
              ?.map((item) => Subject.fromMap(Map<String, dynamic>.from(item)))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'order': order,
      'id': id,
      'key': key,
      'subcategory': subcategory.map((x) => x.toMap()).toList(),
    };
  }

  factory UniversityCategory.fromJson(Map<String, dynamic> json) =>
      UniversityCategory.fromMap(json);
  Map<String, dynamic> toJson() => toMap();
}

class Subject {
  final String text;
  final String link;

  Subject({required this.text, required this.link});

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      link: map['link'] ?? '',
      text: map['text'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'link': link,
    };
  }

  factory Subject.fromJson(Map<String, dynamic> json) => Subject.fromMap(json);
  Map<String, dynamic> toJson() => toMap();
}
