class SimulationModel {
  final String category;
  final int order;
  final String key;
  final List<Subcategory> subcategory;

  SimulationModel({
    required this.category,
    required this.order,
    required this.key,
    required this.subcategory,
  });

  factory SimulationModel.fromJson(Map<String, dynamic> json) {
    return SimulationModel(
      category: json['category'],
      order: json['order'],
      key: json['key'],
      subcategory: List<Subcategory>.from(
        json['subcategory'].map((x) => Subcategory.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'category': category,
        'order': order,
        'key': key,
        'subcategory': subcategory.map((x) => x.toJson()).toList(),
      };
}

class Subcategory {
  final String title;
  final List<String> links;

  Subcategory({required this.title, required this.links});

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      title: json['title'],
      links: List<String>.from(json['links']),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'links': links,
      };
}
