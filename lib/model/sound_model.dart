class SoundModel {
  final String category;
  final int order;
  final List<SoundSubcategory> subcategories;

  SoundModel({
    required this.category,
    required this.order,
    required this.subcategories,
  });

  factory SoundModel.fromJson(Map<String, dynamic> json) {
    return SoundModel(
      category: json['category'] ?? '',
      order: json['order'] ?? 0,
      subcategories: (json['subcategories'] as List? ?? [])
          .map((e) => SoundSubcategory.fromJson(e))
          .toList(),
    );
  }
}

class SoundSubcategory {
  final String name;
  final String ULR;
  final Links links;
  final Word? words;
  final List<SoundPractice>? soundsPractice;

  SoundSubcategory({
    required this.name,
    required this.ULR,
    required this.links,
    this.words,
    this.soundsPractice,
  });

  factory SoundSubcategory.fromJson(Map<String, dynamic> json) {
    final linksValue = json['links'];
    return SoundSubcategory(
      name: json['name'] ?? '',
      ULR: json['ULR'] ?? '',
      links: linksValue is Map
          ? Links.fromJson(Map<String, dynamic>.from(linksValue))
          : Links.empty(),
      words: json['words'] != null ? Word.fromJson(json['words']) : null,
      soundsPractice: json['soundsPractice'] != null
          ? (json['soundsPractice'] as List)
              .map((e) => SoundPractice.fromJson(e))
              .toList()
          : null,
    );
  }
}

class Links {
  final String v1;
  final String v2;
  final String v3;
  final String v4;
  final String v5;

  Links({
    required this.v1,
    required this.v2,
    required this.v3,
    required this.v4,
    required this.v5,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        v1: json['v1'] ?? '',
        v2: json['v2'] ?? '',
        v3: json['v3'] ?? '',
        v4: json['v4'] ?? '',
        v5: json['v5'] ?? '',
      );

  factory Links.empty() => Links(v1: '', v2: '', v3: '', v4: '', v5: '');
}

class Word {
  final String file;
  final String pronun;
  final String syllables;
  final String text;

  Word({
    required this.file,
    required this.pronun,
    required this.syllables,
    required this.text,
  });

  factory Word.fromJson(Map<String, dynamic> json) => Word(
        file: json['file'] ?? '',
        pronun: json['pronun'] ?? '',
        syllables: json['syllables'] ?? '',
        text: json['text'] ?? '',
      );
}

class SoundPractice {
  final String file;
  final String pronun;
  final String syllables;
  final String text;

  SoundPractice({
    required this.file,
    required this.pronun,
    required this.syllables,
    required this.text,
  });

  factory SoundPractice.fromJson(Map<String, dynamic> json) => SoundPractice(
        file: json['file'] ?? '',
        pronun: json['pronun'] ?? '',
        syllables: json['syllables'] ?? '',
        text: json['text'] ?? '',
      );
}
