class FeedbackFormModel {
  FeedbackFormModel({
    required this.sections,
  });

  final List<Section> sections;

  FeedbackFormModel copyWith({
    List<Section>? sections,
  }) {
    return FeedbackFormModel(
      sections: sections ?? this.sections,
    );
  }

  factory FeedbackFormModel.fromJson(Map<String, dynamic> json) {
    return FeedbackFormModel(
      sections: json["sections"] == null
          ? []
          : List<Section>.from(
              json["sections"]!.map((x) => Section.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "sections": sections.map((x) => x?.toJson()).toList(),
      };

  FeedbackFormModel sorted() {
    final sortedSections = sections
        .map((s) => Section(
              subTitle: s.subTitle,
              order: s.order,
              title: s.title,
              questions:
                  List<Question>.from(s.questions), // shallow copy of list
            ))
        .toList();

    sortedSections.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

    for (final section in sortedSections) {
      section.questions.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
    }

    return FeedbackFormModel(sections: sortedSections);
  }
}

class Section {
  Section({
    required this.subTitle,
    required this.order,
    required this.title,
    required this.questions,
  });

  final int? order;
  final String? title;
  final List<Question> questions;
  final String? subTitle;

  Section copyWith({
    int? order,
    String? title,
    List<Question>? questions,
    String? subTitle,
  }) {
    return Section(
      order: order ?? this.order,
      title: title ?? this.title,
      questions: questions ?? this.questions,
      subTitle: subTitle ?? this.subTitle,
    );
  }

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      order: json["order"],
      title: json["title"],
      subTitle: json["subTitle"],
      questions: json["questions"] == null
          ? []
          : List<Question>.from(
              json["questions"]!.map((x) => Question.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "order": order,
        "title": title,
        "subTitle": subTitle,
        "questions": questions.map((x) => x?.toJson()).toList(),
      };
}

class Question {
  Question({
    required this.order,
    required this.text,
    required this.options,
  });

  final int? order;
  final String? text;
  final List<String> options;

  Question copyWith({
    int? order,
    String? text,
    List<String>? options,
  }) {
    return Question(
      order: order ?? this.order,
      text: text ?? this.text,
      options: options ?? this.options,
    );
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      order: json["order"],
      text: json["text"],
      options: json["options"] == null
          ? []
          : List<String>.from(json["options"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "order": order,
        "text": text,
        "options": options.map((x) => x).toList(),
      };
}
