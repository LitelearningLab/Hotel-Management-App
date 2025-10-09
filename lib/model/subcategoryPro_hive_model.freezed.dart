import 'package:hive/hive.dart';

// part 'subcategory_pro.g.dart';

@HiveType(typeId: 0)
class SubcategoryPro extends HiveObject {
  @HiveField(0)
  String file;

  @HiveField(1)
  String isPriority;

  @HiveField(2)
  String syllables;

  @HiveField(3)
  String text;

  @HiveField(4)
  String pronun;

  @HiveField(5)
  int downloadStatus;

  @HiveField(6)
  String localPath;

  @HiveField(7)
  List<String> sentenceSamples;

  @HiveField(8)
  List<String> meaningSamples;

  SubcategoryPro({
    required this.file,
    required this.isPriority,
    required this.syllables,
    required this.text,
    required this.pronun,
    required this.downloadStatus,
    required this.localPath,
    required this.sentenceSamples,
    required this.meaningSamples,
  });
}
