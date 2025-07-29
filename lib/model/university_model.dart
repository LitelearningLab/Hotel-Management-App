class UniversityModel {
  final String collegeName;
  final String collegeId;
  final List<UniversityCategory> category;

  UniversityModel({
    required this.collegeName,
    required this.collegeId,
    required this.category,
  });

  factory UniversityModel.fromMap(Map<String, dynamic> map) {
    return UniversityModel(
      collegeName: map['collegeName'] ?? '',
      collegeId: map['collegeId'] ?? '',
      category: (map['category'] as List<dynamic>?)
              ?.map((item) => UniversityCategory.fromMap(item))
              .toList() ??
          [],
    );
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
}

class Subject {
  final String text;

  Subject({required this.text});

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      text: map['text'] ?? '',
    );
  }
}
