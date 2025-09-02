class ProgressModel {
  final String id; // Headline
  final int option1Time; // in seconds
  final bool option1Done;
  final int option2Time; // in seconds
  final bool option2Done;
  final double percentageEarned;

  ProgressModel({
    required this.id,
    required this.option1Time,
    required this.option1Done,
    required this.option2Time,
    required this.option2Done,
    required this.percentageEarned,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'option1Time': option1Time,
      'option1Done': option1Done ? 1 : 0,
      'option2Time': option2Time,
      'option2Done': option2Done ? 1 : 0,
      'percentageEarned': percentageEarned,
    };
  }

  factory ProgressModel.fromMap(Map<String, dynamic> map) {
    return ProgressModel(
      id: map['id'],
      option1Time: map['option1Time'],
      option1Done: map['option1Done'] == 1,
      option2Time: map['option2Time'],
      option2Done: map['option2Done'] == 1,
      percentageEarned: map['percentageEarned'],
    );
  }
}
