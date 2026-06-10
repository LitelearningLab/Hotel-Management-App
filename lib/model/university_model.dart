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
    return UniversityModel(
      collegeName: map['collegeName'] ?? '',
      collegeId: map['collegeId'] ?? '',
      category: (map['category'] as List<dynamic>?)
              ?.map((item) => UniversityCategory.fromMap(item))
              .toList() ??
          [],
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
}

class UniversityCategory {
  final String name;
  final int order;
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
      order: map['order'] ?? 0,
      id: map['id'] ?? '',
      key: map['key'] ?? '',
      subcategory: (map['subcategory'] as List<dynamic>?)
              ?.map((item) => Subject.fromMap(item))
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
}
