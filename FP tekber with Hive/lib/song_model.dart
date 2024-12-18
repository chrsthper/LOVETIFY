import 'package:hive/hive.dart';

part 'song_model.g.dart';

@HiveType(typeId: 0)
class Song extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String artist;

  @HiveField(2)
  String lyrics;

  @HiveField(3)
  String interpretation;

  Song({
    required this.title,
    required this.artist,
    required this.lyrics,
    required this.interpretation,
  });
}
